//
//  AppDelegate.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 07/10/2016.
//  Copyright © 2016 Lagusoft. All rights reserved.
//

import UIKit

import CoreDataServices
import CoreData
import EasyDownloadSession

/**
 Constant to define the stack for API calls.
 */
let kTVRApiDownloadStack: String = "kTVRApiDownloadStack"

/**
 Constant to define the stack for media download calls.
 */
let kTVRMediaDownloadStack: String = "kTVRMediaDownloadStack"

/**
 Inline function for printing log messages only while on debug configuration.
 */
func DLog(message: String, filename: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
        NSLog("[\(NSURL(fileURLWithPath: filename).lastPathComponent!):\(line)] \(function) - \(message)")
    #endif
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: Root
    
    lazy var navigationController : UINavigationController = {
        
        let _navigationController = RootNavigationController.init()
        _navigationController.setNavigationBarHidden(true, animated: false)
        
        return _navigationController
    }()
    
    //MARK: Window
    lazy var window : UIWindow? = {
        
        let window = Window.init(frame: UIScreen.mainScreen().bounds)
        window.tintAdjustmentMode = .Normal
        
        window.splashViewController = SplashViewController.init()
        window.rootViewController = self.navigationController
        
        window.windowLevel = 1.2
        
        return window
    }()
    
    lazy var fetchRequest: NSFetchRequest = {
        
        let _fetchRequest = NSFetchRequest.init()
        
        _fetchRequest.entity = NSEntityDescription.entityFor(Show.self,
                                                             managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
        
        //  _fetchRequest.predicate = self.showsPredicate;
        _fetchRequest.sortDescriptors = self.sortDescriptorsForFetchRequest
        
        return _fetchRequest
    }()
    
    lazy var sortDescriptorsForFetchRequest: Array <NSSortDescriptor> = {
        
        var postIdSort : NSSortDescriptor = NSSortDescriptor.init(key: "name", ascending: false)
        
        return [postIdSort];
    }()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        ServiceManager.sharedInstance.setupModel("TVShowsReminder")
        
        window!.backgroundColor = .clearColor()
        window!.clipsToBounds = false
        
        registerQueues()
        registerStacks()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        window!.makeKeyAndVisible()
      
        let results: NSArray = try! ServiceManager.sharedInstance.backgroundManagedObjectContext.executeFetchRequest(self.fetchRequest)
       
        for show in results as! [Show] {
            
            DLog ("\(show.name)")
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: RegisterQueues
    
    /**
     Registering operation queues.
     */
    func registerQueues() {
        
        let localDataOperationQueue = NSOperationQueue()
        
        localDataOperationQueue.qualityOfService = .UserInitiated
        OperationCoordinator.sharedInstance.registerQueue(localDataOperationQueue,
 schedulerIdentifier: kTVRLocalDataOperationSchedulerTypeIdentifier)
    }
    
    //MARK: RegisterStacks
    
    /**
     Registering operation stacks.
     */
    func registerStacks() {
        
        let apiStack = Stack()
        
        DownloadSession.sharedInstance.registerStack(stack: apiStack,
                                                     stackIdentifier:kTVRApiDownloadStack)
        
        let mediaStack = Stack()
        
        mediaStack.maxDownloads = 4;
        
        DownloadSession.sharedInstance.registerStack(stack: mediaStack,
                                                     stackIdentifier:kTVRMediaDownloadStack)
    }
}