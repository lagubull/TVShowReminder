//
//  JSCShowPageParser.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 04/03/2016.
//
//

import Foundation
import CoreData
import CoreDataServices

/**
 ShowPage JSON Keys.
*/
let kJSCShows = "posts" as String
let kJSCData = "data" as String
let kJSCPagination = "pagination" as String
let kJSCcurrentPage = "current_page" as String
let kJSCNextPage = "next_page" as String

/**
 Extracts a ShowPage.
*/
class JSCShowPageParser: JSCParser {
    
    //MARK: Page
    
    /**
     Parse Page.
     
     - Parameter pageDictionary: JSON containing a page.
     
     - Returns: JSCShowPage instance that was parsed.
    */
    func parsePage(pageDictionary: Dictionary <String, AnyObject>) -> JSCShowPage! {
        
        let postDictionaries = pageDictionary[kJSCShows]![kJSCData] as! Array <Dictionary <String, AnyObject>>
        
        var page: JSCShowPage?

        if postDictionaries.count > 0 {
            
            let parser = JSCShowParser(managedObjectContext: self.managedObjectContext)
            
            let parsedShows = parser.parseShows(postDictionaries) as Array <JSCShow>
            
            for post in parsedShows {
                
                if post.page == nil {
                    
                    if page == nil {
                        
                        let metaDictionary = pageDictionary[kJSCShows]![kJSCPagination] as! Dictionary <String, AnyObject>
                        
                        page = self.parseMetaDictionary(metaDictionary)
                    }
                    
                    post.page = page;
                }
                else {
                    
                    let metaDictionary = pageDictionary[kJSCShows]![kJSCPagination] as! Dictionary <String, AnyObject>

                    page = self.parseMetaDictionary(metaDictionary)
                }
            }
        }
        
        return page
    }
    
     // Mark: Meta
    
     /**
     Parse meta data about the page.
    
     - Parameter metaDictionary: JSON containing a page meta data.
    
     - Returns: JSCShowPage instance that was parsed.
     */
    func parseMetaDictionary(metaDictionary: Dictionary <String, AnyObject>) -> JSCShowPage! {
        
        guard let context = self.managedObjectContext else { return nil }
        
        let page = NSEntityDescription.insertNewObjectForEntity(JSCShowPage.self,
                                                                managedObjectContext: context) as! JSCShowPage
        
        page.nextPageRequestPath = JSCValueOrDefault(metaDictionary[kJSCNextPage],
                                                     defaultValue: nil) as? String
        
        page.index = JSCValueOrDefault(metaDictionary[kJSCcurrentPage],
                                       defaultValue: nil) as? NSNumber
        
        return page
    }
}