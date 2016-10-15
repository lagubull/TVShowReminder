//
//  Show.swift
//  
//
//  Created by Javier Laguna on 07/10/2016.
//
//

import Foundation
import CoreData
import CoreDataServices

@objc(Show)
class Show: NSManagedObject {

    // MARK: Show
    
    /**
     Retrieves a Show from DB based on TITLE provided.
     
     - Parameter title: title of the show to be retrieved.
     - Parameter managedObjectContext: context that should be used to access persistent store.
     
     - Returns: Show instance or nil if title can't be found.
     */
    class func fetchShow(title: String, managedObjectContext:NSManagedObjectContext) -> Show? {
        
        let predicate = NSPredicate(format:"name == [cd] %@", title)
        
        var post: Show?
        
        post = managedObjectContext.retrieveFirstEntry(Show.self,
                                                       predicate: predicate) as? Show
        
        return post
    }
    
    /**
     Retrieves a SHOW from DB based on ID provided, looking in the mainContext.
     
     - Parameter title: title of the show to be retrieved.
     
     - Returns: Show instance or nil if title can't be found.
     */
    class func fetchShow(title: String) -> Show? {
        
        var show: Show?
        
        show = Show.fetchShow(title, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
        
        return show
    }
}
