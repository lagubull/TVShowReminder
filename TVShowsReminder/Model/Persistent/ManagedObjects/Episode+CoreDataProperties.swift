//
//  Episode+CoreDataProperties.swift
//  
//
//  Created by Javier Laguna on 07/10/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Episode {

    @NSManaged var season: NSNumber?
    @NSManaged var index: NSNumber?
    @NSManaged var title: String?
    @NSManaged var airdate: NSDate?
    @NSManaged var show: Show?

}
