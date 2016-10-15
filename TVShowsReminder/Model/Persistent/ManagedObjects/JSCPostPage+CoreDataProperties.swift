//
//  JSCShowPage+CoreDataProperties.swift
//  
//
//  Created by Javier Laguna on 04/03/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension JSCShowPage {

    @NSManaged var index: NSNumber?
    @NSManaged var nextPageRequestPath: String?
    @NSManaged var post: JSCShow?

}
