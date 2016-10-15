//
//  CDSOperation.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 10/03/2016.
//
//

import Foundation
import CoreDataServices

/**
 Code base for a core data opration.
 */
class CDSOperation: Operation {
    
    //MARK: Save
    
    /**
    Saves the parent managed context if there is changes.
    
    - Parameter result: result to finish with and pass to on success callback.
    */
    func saveLocalContextChangesToMainContext(result: AnyObject?) {
        
        ServiceManager.sharedInstance.backgroundManagedObjectContext.performBlockAndWait {
            
            var didSave = true
            
            do {
                
                try ServiceManager.sharedInstance.backgroundManagedObjectContext.save()
                
                /*
                Coredata will delay cascading deletes for performance so we force them to happen.
                */
                ServiceManager.sharedInstance.backgroundManagedObjectContext.performBlockAndWait {
                    
                    ServiceManager.sharedInstance.backgroundManagedObjectContext.processPendingChanges()
                }
                
                //Don't want changes to be lost if the app crashes so let's save these changes to the persistent store
                ServiceManager.sharedInstance.mainManagedObjectContext.performBlockAndWait {
                    
                    do {
                        
                        try ServiceManager.sharedInstance.mainManagedObjectContext.save()
                        
                        ServiceManager.sharedInstance.mainManagedObjectContext.processPendingChanges()
                    }
                    catch {
                        
                        let nserror = error as NSError
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                        
                        self.didFailWithError(nserror)
                        
                        didSave = false
                    }
                }
            }
            catch {
                
                let localManagedObjectContentSaveError = error as NSError
                
                NSLog("Unresolved error \(localManagedObjectContentSaveError), \(localManagedObjectContentSaveError.userInfo)")
                
                self.didFailWithError(localManagedObjectContentSaveError)
                
                didSave = false
            }
            
            if didSave {
                
                if let unwrappedResult = result {
                    
                    if unwrappedResult.isKindOfClass(NSError.self) {
                        
                        self.didFailWithError(unwrappedResult as? NSError)
                    }
                    else {
                        
                        self.didSucceedWithResult(unwrappedResult)
                    }
                }
                else {
                    
                    self.didSucceedWithResult(result)
                }
            }
        }
    }
    
    /**
     Saves the local managed object context and finishes the execution of the operation.
     
     - Parameter result: result to finish with and pass to on success callback.
     */
    func saveContextAndFinishWithResult(result: AnyObject?) {
        
        let hasChanges = ServiceManager.sharedInstance.backgroundManagedObjectContext.hasChanges;
        
        if hasChanges {
            
            self.saveLocalContextChangesToMainContext(result)
        }
        else {
            
            if let unwrappedResult = result {
                
                if unwrappedResult.isKindOfClass(NSError.self) {
                    
                    self.didFailWithError(unwrappedResult as? NSError)
                }
                else {
                    
                    self.didSucceedWithResult(unwrappedResult)
                }
            }
            else {
                
                self.didSucceedWithResult(result)
            }
        }
    }
}