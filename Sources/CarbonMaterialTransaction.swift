//
//  CarbonMaterialTransaction.swift
//  SwiftApp
//
//  Created by Ermal Kaleci on 30/12/15.
//  Copyright © 2015 Ermal Kaleci. All rights reserved.
//

import UIKit

public class CarbonMaterialTransaction: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var isReverse = false;
    private var duration = 0.3
    private weak var animateView: UIView?
    private weak var transition: UIViewControllerContextTransitioning?
    private weak var fromViewController: UIViewController?
    private weak var toViewController: UIViewController?
    private var point: CGPoint!
    
    override init() {
        super.init()
        point = CGPointZero
    }
    
    convenience public init(fromPoint: CGPoint) {
        self.init()
        point = fromPoint
    }

    public func reverseToPoint(toPoint: CGPoint) -> Self {
        isReverse = true
        point = toPoint
        return self
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        transition = transitionContext
        
        fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let toView = toViewController!.view
        animateView = toView
        
        var timingName = kCAMediaTimingFunctionEaseIn
        
        if isReverse {
            timingName = kCAMediaTimingFunctionEaseOut
            animateView = fromViewController!.view
            transitionContext.containerView()!.addSubview(fromViewController!.view)
        } else {
            transitionContext.containerView()!.addSubview(toView)
        }
                
        let maskLayer = CAShapeLayer()
        animateView!.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = transitionDuration(transitionContext)
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: timingName)
        
        let maxWidth = max(CGRectGetWidth(toView!.frame) - point.x, point.x)
        let maxHeight = max(CGRectGetHeight(toView!.frame) - point.y, point.y)
        
        let widthHeight = sqrt(pow(maxWidth, 2) + pow(maxHeight, 2))
        
        var from = CGRectMake(point.x, point.y, 0, 0)
        var to = CGRectMake(point.x - widthHeight, point.y - widthHeight, widthHeight * 2, widthHeight * 2)
        
        if isReverse {
            swap(&from, &to)
        }
        
        animation.fromValue = UIBezierPath(ovalInRect: from).CGPath
        animation.toValue = UIBezierPath(ovalInRect: to).CGPath
        maskLayer.addAnimation(animation, forKey: nil)
    }
    
    public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        animateView!.layer.mask = nil
        transition?.completeTransition(!(transition?.transitionWasCancelled())!)
    }
    
}
