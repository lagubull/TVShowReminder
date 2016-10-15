//
//  JSCMediaStorageOperation.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 16/03/2016.
//
//

import Foundation
import UIKit

/**
Operation to store an asset in disk.
*/
class JSCMediaStorageOperation: JSCOperation {
    
    /**
     ID of the post the media is related to.
     */
    var postId: String?
    
    /**
     Indicates where the object has been stored by default.
     */
    var data: NSData?
    
    //MARK: Init
    
    required init() {
        
        super.init()
    }
    
    /**
     Creates an operation to store an asset.
     
     @param postId - indicates the post the asset is related to.
     @param location - indicates where the object has been stored by default.
     */
    convenience init (postId: String, data: NSData?) {
        
        self.init()
        
        self.postId = postId;
        self.data = data;
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
    
    private lazy var _identifier : String = {
        
        return "storeLocalImageAssetForShowId \(self.postId!)"
    }()

    //MARK: Start
    
    override func start() {
        
        super.start()
        
        var success = false
        
        //Images in this API are too big to have on a performant cell,
        //in a real app we would keep the original and store also a smaller resolution copy to improve performance, for the test I will only keep the preview
        
        if let unwrappedData = self.data {
            
            let image = UIImage.init(data: unwrappedData)
            
            if var unwrappedImage = image {
                
                unwrappedImage = UIImage.jsc_scaleImage(unwrappedImage)
                unwrappedImage = UIImage.jsc_roundImage(unwrappedImage)
                
                let imageData = UIImageJPEGRepresentation(unwrappedImage, 1.0)
                
                if let unwrappedImageData = imageData {
                    
                    success = JSCFileManager.saveData(unwrappedImageData, toDocumentsDirectoryPath: self.postId!)
                    
                    if success {
                        
                        self.didSucceedWithResult(unwrappedImage)
                    }
                }
            }
        }
        
        if !success {
            
            self.didFailWithError(nil)
        }
    }
    
    //MARK: Cancel
    
    override func cancel() {
        
        super.cancel()
        
        self.didSucceedWithResult(nil)
    }
}
