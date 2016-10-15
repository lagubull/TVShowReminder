//
//  TVRDateFormatter.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 07/03/2016.
//
//

import Foundation

/**
Key to store the dateFormatter in the threads dictionary.
*/
let kTVRDateFormatterKey = "dateFormatterKey" as String

/**
 Key to store the dateFormatter for Upadted Date in the threads dictionary.
 */

let kTVRUpdatedDateDDateFormatterKey = "updatedDateDateFormatterKey" as String

/**
 Manages our date format.
 */
extension NSDateFormatter {
    
    //MARK: DateFormatter
    
    /**
    Convenient method to create a date formatter per thread.
    
    - Returns: NSDateFormmater of the thread we are on.
    */
    class func tvr_dateFormatter() -> NSDateFormatter {
        
        if NSThread.currentThread().threadDictionary[kTVRDateFormatterKey] == nil {
            
            let dateFormatter = NSDateFormatter()
            
            dateFormatter.timeZone = NSTimeZone.init(abbreviation: "UTC")
            dateFormatter.dateFormat = "d MMM yy"
            dateFormatter.locale = NSLocale.init(localeIdentifier: "en_GB")
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            
            NSThread.currentThread().threadDictionary[kTVRDateFormatterKey] = dateFormatter
        }
        
        return NSThread.currentThread().threadDictionary[kTVRDateFormatterKey] as! NSDateFormatter
    }
    
    /**
     Convenient method to create a date formatter per thread.
     
     - Returns: NSDateFormmater of the thread we are on.
     */
    class func tvr_showUpdatedDateFormatter() -> NSDateFormatter {
        
        if NSThread.currentThread().threadDictionary[kTVRUpdatedDateDDateFormatterKey] == nil {
            
            let dateFormatter = NSDateFormatter()
            
            dateFormatter.timeZone = NSTimeZone.init(abbreviation: "UTC")
            dateFormatter.dateFormat = "E, d MMM yyyy -HH:mm"
            dateFormatter.locale = NSLocale.init(localeIdentifier: "en_GB")
                       
            NSThread.currentThread().threadDictionary[kTVRUpdatedDateDDateFormatterKey] = dateFormatter
        }
        
        return NSThread.currentThread().threadDictionary[kTVRUpdatedDateDDateFormatterKey] as! NSDateFormatter
    }

}