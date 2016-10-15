//
//  Window.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 11/03/2016.
//
//

import Foundation
import UIKit

/**
 Custom Window.
 */
class Window: UIWindow {
    
    /**
     View controller to show when the app starts up.
     */
    var splashViewController: UIViewController?
    
    //MARK: SuperClass
    
    override func makeKeyAndVisible() {
        
        super.makeKeyAndVisible()
        
        showSplashScreen()
    }
    
    //MARK: Hide
    
    /**
    Hide the Splash image / video with an animation.
    */
    func hideSplashScreen() {
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.splashViewController!.view.alpha = 0.0
            },
            completion: { (finished) in

                self.splashViewController!.view.removeFromSuperview()
                self.splashViewController = nil;
        })
    }
    
    //MARK: Show
    
    /**
    Adds the spash image view as a subview.
    */
    func showSplashScreen() {
        
        showSplashViewController()
    }
    
    /**
     Adds the spash View Controller as a subview.
     Hide and remove View Controller from superview.
     */
    func showSplashViewController() {
        
        addSubview(splashViewController!.view)
    }
}