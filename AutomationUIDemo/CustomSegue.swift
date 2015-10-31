//
//  CustomSegue.swift
//  AutomationUIDemo
//
//  Created by Zhihao Cui on 30/10/2015.
//  Copyright © 2015 zhihaocui. All rights reserved.
//

import Foundation
import UIKit

class GoUpSegue: UIStoryboardSegue {
    override func perform() {
        // Assign the source and destination views to local variables.
        let firstVCView = self.sourceViewController.view as UIView!
        let secondVCView = self.destinationViewController.view as UIView!
        
        // Get the screen width and height.
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        // Specify the initial position of the destination view.
        secondVCView.frame = CGRectMake(0.0, screenHeight, screenWidth, screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondVCView, aboveSubview: firstVCView)
        
        // Animate the transition.
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            firstVCView.frame = CGRectOffset(firstVCView.frame, 0.0, -screenHeight)
            secondVCView.frame = CGRectOffset(secondVCView.frame, 0.0, -screenHeight)
            
            }) { (Finished) -> Void in
                self.sourceViewController.presentViewController(self.destinationViewController as UIViewController,
                    animated: false,
                    completion: nil)
        }
    }
}

class GoDownSegue: UIStoryboardSegue {
    override func perform() {
        // Assign the source and destination views to local variables.
        let firstVCView = self.sourceViewController.view as UIView!
        let secondVCView = self.destinationViewController.view as UIView!
        
        // Get the screen width and height.
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        // Specify the initial position of the destination view.
        secondVCView.frame = CGRectMake(0.0, -screenHeight, screenWidth, screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondVCView, aboveSubview: firstVCView)
        
        // Animate the transition.
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            firstVCView.frame = CGRectOffset(firstVCView.frame, 0.0, screenHeight)
            secondVCView.frame = CGRectOffset(secondVCView.frame, 0.0, screenHeight)
            
            }) { (Finished) -> Void in
                self.sourceViewController.presentViewController(self.destinationViewController as UIViewController,
                    animated: false,
                    completion: nil)
        }
    }
}

class UnwindGoRightSegue: UIStoryboardSegue {
    override func perform() {
        let fromView = self.sourceViewController.view
        
        let toView = self.destinationViewController.view
        
        if let containerView = fromView.superview {
            
            let initialFrame = fromView.frame
            
            var offscreenRect = initialFrame
            
            offscreenRect.origin.x -= CGRectGetWidth(initialFrame)
            
            toView.frame = offscreenRect
            
            containerView.addSubview(toView)
            
            // Being explicit with the types NSTimeInterval and CGFloat are important
            
            // otherwise the swift compiler will complain
            
            let duration: NSTimeInterval = 0.5
            
            UIView.animateWithDuration(duration, animations: {
                    fromView.frame.origin.x += fromView.frame.width
                    toView.frame = initialFrame
                    
                }, completion: { finished in
                    
                    toView.removeFromSuperview()
                    
                    if let navController = self.destinationViewController.navigationController {
                        
                        navController.popToViewController(self.destinationViewController, animated: false)
                        
                    }
                    
            })
        }
    }
}