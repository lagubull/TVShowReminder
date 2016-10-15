//
//  JSCShowPage.swift
//
//
//  Created by Javier Laguna on 04/03/2016.
//
//

import Foundation
import CoreData
import CoreDataServices

class JSCShowPage: NSManagedObject {
    
    /**
     Retrieves the last page of posts stored in the context.
     
     - Parameter context: context in which we want to perform the search.
     
     - Returns: JSCShowPage - instace of the JSCShowPage class
     */
    class func fetchLastPageInContext(managedObjectContext: NSManagedObjectContext) -> JSCShowPage {
        
        let retrievedPagesSortDescriptor = NSSortDescriptor.init(key: "index", ascending: false)
        
        let sortDescriptors = [retrievedPagesSortDescriptor]
        
        return managedObjectContext.retrieveFirstEntry(JSCShowPage.self,
                                                       predicate: nil,
                                                       sortDescriptors: sortDescriptors) as! JSCShowPage
    }
    
}
