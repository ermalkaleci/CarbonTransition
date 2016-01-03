//  The MIT License (MIT)
//
//  Copyright (c) 2016 Ermal Kaleci
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

public class CarbonMaterialTransaction: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var point: CGPoint!
    public var identifier: String?
    public var duration: Double = 0.5
    
    private var isReverse = false;
    private weak var animateView: UIView?
    private weak var transition: UIViewControllerContextTransitioning?
    private weak var fromViewController: UIViewController?
    private weak var toViewController: UIViewController?
    
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
        
        animateView = toViewController!.view
        var timingName = kCAMediaTimingFunctionEaseIn
        
        if isReverse {
            animateView = fromViewController!.view
            timingName = kCAMediaTimingFunctionEaseOut
            transitionContext.containerView()!.addSubview(animateView!)
        } else {
            transitionContext.containerView()!.addSubview(animateView!)
        }
                
        let maskLayer = CAShapeLayer()
        animateView!.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = transitionDuration(transitionContext)
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: timingName)
        
        let maxWidth = max(CGRectGetWidth(animateView!.frame) - point.x, point.x)
        let maxHeight = max(CGRectGetHeight(animateView!.frame) - point.y, point.y)
        
        let widthHeight = sqrt(pow(maxWidth, 2) + pow(maxHeight, 2))
        
        var from = CGRectMake(
            point.x, point.y,
            0, 0
        )
        
        var to = CGRectMake(
            point.x - widthHeight, point.y - widthHeight,
            widthHeight * 2, widthHeight * 2
        )
        
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
