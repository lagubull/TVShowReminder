//
//  NSNumberFormatter.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 11/10/2016.
//  Copyright © 2016 Lagusoft. All rights reserved.
//

import UIKit

import Foundation

/**
 Key to store the numberFormatter in the threads dictionary.
 */
let kTVRNumberFormatterKey = "numberFormatterKey" as String

/**
 Manages our number format.
 */
extension NSNumberFormatter {
    
    //MARK: numberFormatter
    
    /**
     Convenient method to create a number formatter per thread.
     
     - Returns: NSNumberFormatter of the thread we are on.
     */
    class func tvr_numberFormatter() -> NSNumberFormatter {
        
        if NSThread.currentThread().threadDictionary[kTVRNumberFormatterKey] == nil {
            
            let numberFormatter = NSNumberFormatter()
            
            numberFormatter.numberStyle = .NoStyle
            
            NSThread.currentThread().threadDictionary[kTVRNumberFormatterKey] = numberFormatter
        }
        
        return NSThread.currentThread().threadDictionary[kTVRNumberFormatterKey] as! NSNumberFormatter
    }
}
