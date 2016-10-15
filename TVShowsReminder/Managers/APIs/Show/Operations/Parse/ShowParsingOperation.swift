//
//  ShowParsingOperation.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 10/03/2016.
//
//

import Foundation
import CoreDataServices

/**
 Parses the data corresponding to a show.
 */
class ShowParsingOperation: CDSOperation {
    
    /**
     Data to parse.
     */
    private var data: NSData?
    
    /**
     Name of the show to parse.
     */
    private var showName: String?
    
    private static let inputElementName = "div"
    private static let valueAttributeName = "value"
    private static let nameAttributeName = "id"
    
    //MARK: Init
    
    /**
    Creates an operation to retrieve a feed.
    
    - Parameter showName: Name of the show to parse.
    - Parameter Data: Data to parse.
    
    - Returns: an instance of the class.
    */
    required convenience init(showName: String, data: NSData?) {
        
        self.init()
        
        self.data = data
        self.showName = showName
    }
    
    //MARK: Identifier
    
    override var identifier: String? {
        
        get {
            
            return _identifier
        }
        set {
            
            willChangeValueForKey("identifier")
            self._identifier = newValue!
            didChangeValueForKey("identifier")
        }
    }
    
    private lazy var _identifier: String = {
        
        return "parseShow \(self.showName)"
    }()
    
    //MARK: Start
    
    override func start() {
        
        super.start()
        
        if let unwrappedData = data {
            
            var showSiteSource: String!
            
            showSiteSource = NSString(data: unwrappedData, encoding: NSUTF8StringEncoding) as String!
            
            let showParser = ShowParser.parserWithContext(ServiceManager.sharedInstance.backgroundManagedObjectContext)
            
            ServiceManager.sharedInstance.backgroundManagedObjectContext.performBlockAndWait {
                
                showParser.parseShow(showSiteSource)
                
                self.saveContextAndFinishWithResult(nil)
            }
        }
        else {
                
                self.didFailWithError(nil)
            }
    }
    
    static func parseEpisodeListFromForm(form: String) -> String? {
        
        return parseValueForElementWithNameAttributeValue("eplist", fromForm: form)
    }
    
    private static func parseValueForElementWithNameAttributeValue(nameAttributeValue: String, fromForm form: String) -> String? {
        
        // XML needs to have single root element
        let wrappedForm = "<root>\(form)</root>"
        let data = wrappedForm.dataUsingEncoding(NSUTF8StringEncoding)!
        let parser = XmlElementAttributeParser(
            elementName: inputElementName,
            attribute: (nameAttributeName, nameAttributeValue),
            parsedAttributeName: valueAttributeName,
            data: data)
        
        return parser.parse();
    }
    
    //MARK: Cancel
    
    override func cancel() {
        
        super.cancel()
        
        self.didSucceedWithResult(nil)
    }
}