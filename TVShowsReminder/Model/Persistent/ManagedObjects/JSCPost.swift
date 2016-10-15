//
//  JSCShow.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 04/03/2016.
//
//

import Foundation
import CoreData
import CoreDataServices

class JSCShow: NSManagedObject {
    
    // MARK: Show
    
    /**
    Retrieves a JSCPOST from DB based on ID provided.
    
    - Parameter postId: ID of the post to be retrieved.
    - Parameter managedObjectContext: context that should be used to access persistent store.
    
    - Returns: JSCPOST instance or nil if POST can't be found.
    */
    class func fetchShowWithId(postId: String, managedObjectContext:NSManagedObjectContext) -> JSCShow? {
        
        let predicate = NSPredicate(format:"postId MATCHES %@", postId)
        
        var post: JSCShow?
        
        post = managedObjectContext.retrieveFirstEntry(JSCShow.self,
                                                       predicate: predicate) as? JSCShow
        
        return post
    }
    
    /**
     Retrieves a JSCPOST from DB based on ID provided, looking in the mainContext.
     
     - Parameter postId: ID of the post to be retrieved.
     
     - Returns: JSCPOST instance or nil if POST can't be found.
     */
    class func fetchShowWithId(postId: String) -> JSCShow? {
        
        var post: JSCShow?
        
        post = JSCShow.fetchShowWithId(postId, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
        
        return post
    }
    
    // MARK: UserName
    
    /**
    Convenient method to shape the user's name into the desired format.
    
    - Returns: user's Name.
    */
    func userName() -> String {
        
        let lastNameFirstLetter = self.userLastName![self.userLastName!.startIndex]
        
        return "\(self.userFirstName!) \(lastNameFirstLetter).";
    }
}
