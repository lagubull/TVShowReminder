 //
//  ShowParser.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 11/10/2016.
//  Copyright © 2016 Lagusoft. All rights reserved.
//

import CoreData
import CoreDataServices
import Fuzi

/**
 Extracts a Show.
 */
class ShowParser: Parser {
    
    //MARK: Show
    
    /**
     Parses a Show.
     
     - Parameter showSiteSource: String containing a show.
     
     - Returns: Show instance that was parsed.
     */
    func parseShow(showSiteSource: String) -> Show! {
        
        var show: Show!
        
        guard let managedObjectContext = self.managedObjectContext else { return show }
        
        let episodeParser = EpisodeParser.parserWithContext(managedObjectContext)
        
        let title = extractTitle(showSiteSource)
        
        DLog("\(title)")
        
        if title != "" {
            
            show = Show.fetchShow(title, managedObjectContext: managedObjectContext)
            
            if show == nil {
                
                show = NSEntityDescription.insertNewObjectForEntity(Show.self,
                                                                    managedObjectContext: managedObjectContext) as? Show
                
                show?.name = title
            }
            
            guard let show = show else { return nil }
            
            show.lastUpdated = extractLastUpdated(showSiteSource)
            show.status = extractStatus(showSiteSource)
                
            episodeParser.parseEpisodes(showSiteSource, show: show)
        }
        
        return show
    }
    
    private func extractStatus(showSiteSource: String) -> String {
        
        var status = ""
        
        do {
            
            let doc = try HTMLDocument(string: showSiteSource, encoding: NSUTF8StringEncoding)
            
            let element = searchForTag("status", type: "span", element: doc.body!)
            
            if element != nil {
                
                status = element!.description
                
                status = status.stringByReplacingOccurrencesOfString("<[^>]+>",
                                                                     withString: "",
                                                                     options: .RegularExpressionSearch,
                                                                     range: nil)
            }
        } catch let error {
            
            print(error)
            
            return status
    }
    
    return status
}


    private func extractLastUpdated(showSiteSource: String) -> NSDate {
        
        var lastDateUpdated: NSDate?
        
        do {
            var lastDateString = ""
            
            let doc = try HTMLDocument(string: showSiteSource, encoding: NSUTF8StringEncoding)
            
             if doc.body!.children(tag: "div")[1].children(tag: "table")[1].children(tag: "tr")[0].children(tag:"td")[0].children(tag: "h3")[0].children[0].description == "<strong>Last updated:</strong>" &&
                doc.body!.children(tag: "div")[1].children(tag: "table")[1].children(tag: "tr")[0].children(tag:"td")[0].children(tag: "h3")[0].children[2].description.hasPrefix("<em>") {
                
            lastDateString = doc.body!.children(tag: "div")[1].children(tag: "table")[1].children(tag: "tr")[0].children(tag:"td")[0].children(tag: "h3")[0].children[2].description
            
            lastDateString = lastDateString.stringByReplacingOccurrencesOfString("<[^>]+>",
                                                                           withString: "",
                                                                           options: .RegularExpressionSearch,
                                                                           range: nil)
                
                let dateFormatter = NSDateFormatter.tvr_showUpdatedDateFormatter() as NSDateFormatter
                
                lastDateUpdated = dateFormatter.dateFromString("Sat, 3 Sep 2016 -1:00")
            }

        } catch let error {
            
            print(error)
            
            return NSDate()
        }
        
        return lastDateUpdated!
    }
            
    private func extractTitle(showSiteSource: String) -> String {
        
        var title = ""
        
        do {
            
            let doc = try HTMLDocument(string: showSiteSource, encoding: NSUTF8StringEncoding)
            
            let titleString = (doc.head?.children(tag: "title").description)!
            
            title = titleString.stringByReplacingOccurrencesOfString("(a Titles &amp;[^)]+)",
                                                                     withString: "",
                                                                     options: .RegularExpressionSearch,
                                                                     range: nil)
            
            title = title.stringByReplacingOccurrencesOfString("<[^>]+>",
                                                               withString: "",
                                                               options: .RegularExpressionSearch,
                                                               range: nil)
            
            title = title.stringByReplacingOccurrencesOfString("[", withString: "")
            
            title = title.stringByReplacingOccurrencesOfString("]", withString: "")
            
            title = title.stringByReplacingOccurrencesOfString(" ()", withString: "")
            
        } catch let error {
            
            print(error)
            
            return title
        }
        
        return title
    }

    private func searchForTag(tag: String, type: String, element: XMLElement) -> XMLElement? {
        
        if element.tag == type {
            
            var shouldReturn = false
            
            for element in element.attributes {
                
                if element.1 == tag {
                    
                    shouldReturn = true
                }
            }

            if shouldReturn {
                
                return element
            }
        }
        else {
            
            for element in element.children {
                
                let newElement = searchForTag(tag, type: type, element: element)
                
                if newElement != nil {
                    
                    return newElement
                }
            }
        }
        
        return nil
    }
    
    
    private func searchThroughTags(tags: [String], element: XMLElement, pointer: Int) -> XMLElement? {
    
        if element.tag == tags[pointer] {
            
            var newPointer = pointer + 1
            
           // var shouldReturn = true
            
            return searchThroughTags(tags, element: element, pointer: newPointer)
            
            // if element.children(tag: "tr")[0].children(tag:"td")[0].children(tag: "h3")[0].children[0].description == "<strong>Last updated:</strong>" {
            
            // if element.children(tag: "tr")[0].children(tag:"td")[0].children(tag: "h3")[0].children[2].description == "<em>Thu, 1 Sep 2016 -1:00</em>" {
            //            for element in element.attributes {
            //
            //                if element.1 == tag {
            //
            //  shouldReturn = true
            // }
            // }
            //
//            if shouldReturn {
//                
//                return element
//            }
        }
        else {
            
            for element in element.children {
                
                let newElement = searchThroughTags(tags, element: element, pointer: 0)
                
                if newElement != nil {
                    
                    return newElement
                }
            }
        }
        
        return nil
    }
}
