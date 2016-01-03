# CarbonTransition

**CarbonTransition v0.1**

**This version is unstable. Use at your own risk!**

**CarbonMaterialTransition**

![img](https://github.com/ermalkaleci/CarbonTransition/blob/master/Screenshots/CarbonMaterialTransition.gif)

# SAMPLE CODE
```swift
class YourViewController: UIViewController, UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CarbonMaterialTransaction(fromPoint: startPoint)
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CarbonMaterialTransaction().reverseToPoint(endPoint)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.destinationViewController.modalPresentationStyle = .Custom
        segue.destinationViewController.transitioningDelegate = self
    }

```

# LICENSE
[The MIT License (MIT)](https://github.com/ermalkaleci/CarbonTransition/blob/master/LICENSE)
