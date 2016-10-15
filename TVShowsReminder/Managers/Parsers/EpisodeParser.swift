//
//  EpisodeParser.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 11/10/2016.
//  Copyright © 2016 Lagusoft. All rights reserved.
//

import CoreData
import CoreDataServices
import Fuzi

/**
 Extracts an Episode.
 */
class EpisodeParser: Parser {
    
    //MARK: Episode
    
    /**
     Parses a Episode.
     
     - Parameter showSiteSource: String containing a show.
     
     - Returns: Episode instance that was parsed.
     */
    func parseEpisodes(showSiteSource: String, show: Show) {
        
        do {
            
            let doc = try HTMLDocument(string: showSiteSource, encoding: NSUTF8StringEncoding)
            
            let element = searchForTag("eplist", element: doc.body!)
            
            var elementString = element!.rawXML as String
            
            elementString = elementString.stringByReplacingOccurrencesOfString("&#13;\n", withString: "\n")
            elementString = elementString.stringByReplacingOccurrencesOfString("&#13;", withString: "\n")
            elementString = elementString.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
            let episodesRawArray = elementString.componentsSeparatedByString("\n")
            
            var season: String = "0"
            
            for episode in episodesRawArray {
                
                if episode != ""  &&
                    episode != "  Episode #     Prod #      Air Date   Titles" &&
                    episode != "<pre>" &&
                    episode != "<div id=\"eplist\">" &&
                    episode != "</div>" &&
                    episode != "</pre>"  &&
                    episode != "                            Original" &&
                    episode != "_____ ______ ___________  ___________ ___________________________________________" {
                    
                    if episode.containsString("Season") {
                        
                        let seasonArray = episode.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                        
                        season = seasonArray.joinWithSeparator("")
                    }
                    else {
                        
                        if episode.containsString("Specials") {
                            
                            season = episode
                        }
                        else {
                            
                            self.parseEpisode(episode, show: show, season: season)
                        }
                    }
                }
            }
        } catch let error {
            
            print(error)
        }
    }
    
    private func parseEpisode(episodeString: String!, show: Show, season: String) {
        
        var episode: Episode?
        
        guard let managedObjectContext = self.managedObjectContext else { return }
        
        let episodeRawArray = episodeString.componentsSeparatedByString("   ")
        
        let title = extractTitle(episodeRawArray[episodeRawArray.count - 1])
        
        DLog("\(title)")
        
        if title != "" {
            
            episode = Episode.fetchEpisode(title, show: show, managedObjectContext: managedObjectContext)
            
            if episode == nil {
                
                episode = NSEntityDescription.insertNewObjectForEntity(Episode.self,
                                                                       managedObjectContext: managedObjectContext) as? Episode
                
                episode?.show = show
                episode?.title = title
            }
            
            guard let episode = episode else { return }
            
            episode.index = TVRValueOrDefault(extractIndex(episodeRawArray[1]), defaultValue: nil) as? NSNumber
            
            episode.airdate = TVRValueOrDefault(extractAirDate(episodeRawArray[episodeRawArray.count - 2]), defaultValue: nil) as? NSDate
            
            let numberFormatter = NSNumberFormatter.tvr_numberFormatter() as NSNumberFormatter
            
            episode.season =  numberFormatter.numberFromString(season)
        }
    }
    
    //MARK: - Attributes
    
    private func extractIndex(indexString: String) -> NSNumber? {
     
        let numberFormatter = NSNumberFormatter.tvr_numberFormatter() as NSNumberFormatter
        
        let indexRaw = indexString.componentsSeparatedByString("-")
        
        let index = indexRaw[1]
        
        return numberFormatter.numberFromString(index)
    }
    
    private func extractTitle(titleString: String) -> String {
        
        let title = titleString.stringByReplacingOccurrencesOfString("<[^>]+>",
                                                                     withString: "",
                                                                     options: .RegularExpressionSearch,
                                                                     range: nil)
         return title
    }
    
    private func extractAirDate(dateString: String) -> NSDate? {
        
        let dateFormatter = NSDateFormatter.tvr_dateFormatter() as NSDateFormatter
        
        let curatedDateString = dateString.stringByTrimmingCharactersInSet(
        
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        return dateFormatter.dateFromString(curatedDateString)
    }
    
    private func searchForTag(tag: String, element: XMLElement) -> XMLElement? {
        
        if element.tag == "div" {
            
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
                
                let newElement = searchForTag(tag, element: element)
                
                if newElement != nil {
                    
                    return newElement
                }
            }
        }
        
        return nil
    }
}
