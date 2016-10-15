//
//  AddShowOperation.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 10/10/2016.
//  Copyright © 2016 Lagusoft. All rights reserved.
//

import CoreDataServices

class AddShowOperation: CDSOperation {

    /**
     Data to parse.
     */
    private var showName: String?
    
    //MARK: Init
    
    /**
     Creates an operation to retrieve a feed.
     
     - Parameter: name: name of the show to store.
     
     - Returns: an instance of the class.
     */
    required convenience init(showName: String?) {
        
        self.init()
        
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
        
        return "addShow\(self.showName)"
    }()
    
    //MARK: Start
    
    override func start() {
        
        super.start()
    }
    
    //MARK: Cancel
    
    override func cancel() {
        
        super.cancel()
        
        self.didSucceedWithResult(nil)
    }
    
}
