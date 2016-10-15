//
//  JSCLocalImageAssetRetrievalOperation.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 16/03/2016.
//
//

import Foundation
import UIKit

/**
 Operation to retrieve an asset from disk.
*/
class JSCLocalImageAssetRetrievalOperation: JSCOperation {

    /**
     ID of the post the media is related to.
     */
    var postId: String?
    
    //MARK: Init
    
    /**
    Creates an operation to retrieve an asset from disk.
    
    - Parameter postId: indicates the post the asset is related to.
    */
    convenience required init(postId: String) {
    
        self.init()
        
        self.postId = postId;
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
    
    private lazy var _identifier :String = {
        
        return "retrieveLocalImageAssetForShowId \(self.postId!)"
    }()
    
    //MARK: Start
    
    override func start() {
        
        super.start()
        
        var imageFromDisk: UIImage?
        
        let imageData = JSCFileManager.retrieveDataFromDocumentsDirectoryWithPath(self.postId!)
        
        if let imageData = imageData {
            
            imageFromDisk = UIImage.init(data: imageData)
        }
        
        self.didCompleteWithResult(imageFromDisk)
    }
    
    //MARK: Cancel
    
    override func cancel() {
        
        super.cancel()
        
        self.didSucceedWithResult(nil)
    }
}
