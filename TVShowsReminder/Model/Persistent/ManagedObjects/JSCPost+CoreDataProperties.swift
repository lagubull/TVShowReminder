//
//  JSCShow+CoreDataProperties.swift
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

extension JSCShow {

    @NSManaged var commentCount: NSNumber?
    @NSManaged var content: String?
    @NSManaged var createdAt: NSDate?
    @NSManaged var likeCount: NSNumber?
    @NSManaged var postId: String?
    @NSManaged var userAvatarRemoteURL: String?
    @NSManaged var userFirstName: String?
    @NSManaged var userLastName: String?
    @NSManaged var page: JSCShowPage?

}
