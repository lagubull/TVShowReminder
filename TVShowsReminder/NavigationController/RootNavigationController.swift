//
//  RootNavigationController.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 15/03/2016.
//
//

import Foundation
import UIKit

/**
 Handles the navigation in the app.
*/
class RootNavigationController: UINavigationController, UINavigationControllerDelegate {

    var homeViewController: HomeViewController?
    
    //MARK: Init
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        
        self.init(rootViewController: HomeViewController.init())
        
        self.delegate = self
    }
    
    override init(rootViewController: UIViewController) {
        
        super.init(rootViewController: rootViewController)
        
        self.homeViewController = rootViewController as? HomeViewController;
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}
