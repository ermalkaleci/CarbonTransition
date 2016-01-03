//
//  FirstViewController.swift
//  CarbonMaterialTransition
//
//  Created by Ermal Kaleci on 30/12/15.
//  Copyright © 2015 Ermal Kaleci. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet var redPlusButton: UIButton!
    @IBOutlet var asphaltPlusButton: UIButton!
    
    private var transition: CarbonMaterialTransaction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if transition?.identifier == "asphaltColor" {
            return transition!.reverseToPoint(asphaltPlusButton.center)
        }
        return transition!.reverseToPoint(redPlusButton.center)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        transition = CarbonMaterialTransaction(fromPoint: redPlusButton.center)
        
        let navigationController = segue.destinationViewController as! UINavigationController
        
        navigationController.modalPresentationStyle = .Custom
        navigationController.transitioningDelegate = self
        
        let destinationViewController = navigationController.topViewController as? SecondViewController
        destinationViewController?.color = UIColor.redColor()
        
        if segue.identifier == "asphaltColor" {
            transition = CarbonMaterialTransaction(fromPoint: asphaltPlusButton.center)
            let asphaltColor = UIColor(red: 52.0/255, green: 73.0/255, blue: 95.0/255, alpha: 1)
            destinationViewController?.color = asphaltColor
        }
        
        transition?.identifier = segue.identifier
    }
}

