//
//  JSCShowParser.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 06/03/2016.
//
//

import Foundation
import CoreData
import CoreDataServices

/**
Show JSON Keys.
*/
let kJSCShowId = "id" as String
let kJSCLikeCount = "like_count" as String
let kJSCCommentCount = "comment_count" as String
let kJSCContent = "content" as String
let kJSCUser = "user" as String
let kJSCAvatar = "avatar" as String
let kJSCFirstName = "first_name" as String
let kJSCLastName = "last_name" as String
let kJSCCreatedAt = "created_at" as String

/**
 Extracts a Show.
 */
class JSCShowParser: JSCParser {
    
    //MARK: Shows
    
    /**
    Parse array of posts.
    
    - Parameter postsDictionaries: array of dictionaries with posts.
    
    - Returns: NSArray of posts.
    */
    func parseShows(postsDictionaries: Array <Dictionary <String, AnyObject>>) -> Array <JSCShow> {
        
        var posts: Array <JSCShow> = []
        
        for postDictionary in postsDictionaries {
            
            let post = self.parseShow(postDictionary)
            
            posts.append(post)
        }
        
        return posts
    }
    
    //MARK: Show
    
    /**
    Parse Show.
    
    - Parameter postDictionary: JSON containing a post.
    
    - Returns: JSCShowPage instance that was parsed.
    */
    func parseShow(postDictionary: Dictionary <String, AnyObject>) -> JSCShow! {
        
        var post: JSCShow!
        
        guard let managedObjectContext = self.managedObjectContext else { return post }
        
        if postDictionary[kJSCShowId] != nil {
            
            let postId = "\(postDictionary[kJSCShowId]!)"
            
            post = JSCShow.fetchShowWithId(postId,
                                           managedObjectContext: managedObjectContext)
            
            if post == nil {
                
                post = NSEntityDescription.insertNewObjectForEntity(JSCShow.self,
                                                                    managedObjectContext: managedObjectContext) as!JSCShow
                post.postId = postId
            }
            
            let dateFormatter = NSDateFormatter.jsc_dateFormatter() as NSDateFormatter
            
            post.createdAt = JSCValueOrDefault(dateFormatter.dateFromString("\(postDictionary[kJSCCreatedAt])"),
                                               defaultValue: post.createdAt) as? NSDate
            
            post.likeCount = JSCValueOrDefault(postDictionary[kJSCLikeCount],
                                               defaultValue: post.likeCount) as? NSNumber
            
            post.content = JSCValueOrDefault(postDictionary[kJSCContent],
                                             defaultValue: post.content)  as? String
            
            post.commentCount = JSCValueOrDefault(postDictionary[kJSCCommentCount],
                                                  defaultValue: post.commentCount)  as? NSNumber
            
            if let userDictionary = postDictionary[kJSCUser] {
                
                post.userAvatarRemoteURL = JSCValueOrDefault(userDictionary[kJSCAvatar],
                                                             defaultValue: post.userAvatarRemoteURL) as? String
                
                post.userFirstName = JSCValueOrDefault(userDictionary[kJSCFirstName],
                                                       defaultValue: post.userFirstName) as? String
                
                post.userLastName = JSCValueOrDefault(userDictionary[kJSCLastName],
                                                      defaultValue: post.userLastName) as? String
            }
            
        }
        
        return post;
    }
}
      