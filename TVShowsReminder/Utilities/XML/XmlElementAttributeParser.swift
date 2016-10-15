//
//  XmlElementAttributeParser.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 10/10/2016.
//  Copyright © 2016 Lagusoft. All rights reserved.
//

import Foundation

class XmlElementAttributeParser: NSObject, NSXMLParserDelegate {
    
    private let elementName: String
    private let attribute: (name:String, value:String)
    private let parsedAttributeName: String
    private let parser: NSXMLParser
    
    private var parsed = false
    private var foundValue: String?
    
    init(elementName: String, attribute: (name:String, value:String), parsedAttributeName: String, data: NSData) {
        
        self.elementName = elementName
        self.attribute = attribute
        self.parsedAttributeName = parsedAttributeName
        parser = NSXMLParser(data: data)
    }
    
    func parse() -> String? {
        
        if !parsed {
            
            parser.delegate = self
            parser.parse()
        }
        return foundValue
    }
    
    // MARK: - NSXMLParserDelegate
    
    func parser(parser: NSXMLParser,
                didStartElement elementName: String,
                                namespaceURI _namespaceURI: String?,
                                             qualifiedName qName: String?,
                                                           attributes attributeDict: [String:String]) {
        
        guard self.elementName == elementName else {
            
            return
        }
        
        guard let attributeValue = attributeDict[attribute.name] where attributeValue == attribute.value else {
            
            return
        }
        
        guard let parsedAttributeValue = attributeDict[parsedAttributeName] else {
            
            return
        }
        
        foundValue = parsedAttributeValue
        parsed = true
        parser.abortParsing()
    }
}