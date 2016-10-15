//
//  Episode.swift
//  
//
//  Created by Javier Laguna on 07/10/2016.
//
//

import Foundation
import CoreData
import CoreDataServices

@objc(Episode)
class Episode: NSManagedObject {

    // MARK: Episode
    
    /**
     Retrieves an Episode from DB based on TITLE provided.
     
     - Parameter title: title of the episode to be retrieved.
     - Parameter show: show the episode belongs to.
     - Parameter managedObjectContext: context that should be used to access persistent store.
     
     - Returns: Episode instance or nil if title can't be found.
     */
    class func fetchEpisode(title: String, show: Show, managedObjectContext:NSManagedObjectContext) -> Episode? {
        
        let predicate = NSPredicate(format:"title == [cd] %@ AND show.name == [cd] %@", title, show.name!)
        
        var episode: Episode?
        
        episode = managedObjectContext.retrieveFirstEntry(Episode.self,
                                                          predicate: predicate) as? Episode
        
        return episode
    }
    
    /**
     Retrieves an Episode from DB based on ID provided, looking in the mainContext.
     
     - Parameter title: title of the show to be retrieved.
     - Parameter show: show the episode belongs to.
     
     - Returns: Episode instance or nil if title can't be found.
     */
    class func fetchShowWithId(title: String, show: Show) -> Episode? {
        
        var episode: Episode?
        
        episode = Episode.fetchEpisode(title, show: show, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
        
        return episode
    }
    
    /**
     Creates the predicate to get the episodes of a show.
     
     - Parameter show: show the episode belongs to.
     
     - Returns: predicate to get the episodes of a show.
     */
    class func episodesPredicateWithShow(show: Show) -> NSPredicate {
        
        return NSPredicate(format:"show.name == [cd] %@", show.name!)
    }
}
