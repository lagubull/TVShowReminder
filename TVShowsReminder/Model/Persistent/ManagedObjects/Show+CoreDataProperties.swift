//
//  Show+CoreDataProperties.swift
//  
//
//  Created by Javier Laguna on 14/10/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Show {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var status: String?
    @NSManaged var lastUpdated: NSDate?
    @NSManaged var episodes: NSSet?

}
