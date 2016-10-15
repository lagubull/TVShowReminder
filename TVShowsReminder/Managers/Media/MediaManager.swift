//
//  JSCMediaManager.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 16/03/2016.
//
//

import Foundation

import EasyDownloadSession

/**
 Manages the media retrival processes.
 */
class JSCMediaManager {
    
    /**
     Retrieves a media for a post.
     
     - Parameter post: post which we want media for.
     - Parameter retrievalRequired: block to execute while a download is in progress.
     - Parameter succes: closure to execute in case of success.
     - Parameter failure: closure to execute on failure.
     */
    class func retrieveMediaForShow(post: JSCShow, retrievalRequired: ((postId: String) -> Void)?, success: ((result: AnyObject?, postId: String) -> Void)?, failure: ((error: NSError?, postId: String) -> Void)?) {
        
        let mySuccess = success
        let myFailure = failure
        
        if post.userAvatarRemoteURL != nil {
            
            let operation = JSCLocalImageAssetRetrievalOperation.init(postId: post.postId!)
            
            operation.onCompletion = { JSCOperationOnCompletionCallback in
                
                if let imageMedia = JSCOperationOnCompletionCallback {
                    
                    mySuccess?(result: imageMedia,
                               postId: post.postId!)
                }
                else {
                    
                    retrievalRequired?(postId: post.postId!)
                    
                    DownloadSession.scheduleDownloadWithId(post.postId!,
                                                           fromURL: NSURL.init(string: post.userAvatarRemoteURL!)!,
                                                           stackIdentifier: kTVRMediaDownloadStack,
                                                           progress: nil,
                                                           completion: { (taskInfo: DownloadTaskInfo!, responseData: NSData?, error: NSError?) -> Void in
                                                            
                                                            if error == nil {
                                                                
                                                                let storeOperation = JSCMediaStorageOperation.init(postId: post.postId!, data: responseData)
                                                                
                                                                storeOperation.onSuccess = { JSCOperationOnSuccessCallback in
                                                                    
                                                                    if let imageMedia = JSCOperationOnSuccessCallback {
                                                                        
                                                                        mySuccess?(result: imageMedia, postId: post.postId!)
                                                                    }
                                                                    else {
                                                                        
                                                                        myFailure?(error: nil, postId: post.postId!)
                                                                    }
                                                                }
                                                                
                                                                storeOperation.onFailure = { JSCOperationOnFailureCallback in
                                                                    
                                                                    myFailure?(error: nil, postId: post.postId!)
                                                                }
                                                                
                                                                storeOperation.targetSchedulerIdentifier = kJSCLocalDataOperationSchedulerTypeIdentifier
                                                                
                                                                JSCOperationCoordinator.sharedInstance.addOperation(storeOperation)
                                                            }
                                                            else {
                                                                
                                                                myFailure?(error: error, postId: post.postId!)
                                                            }
                    })
                }
            }
            
            operation.targetSchedulerIdentifier = kJSCLocalDataOperationSchedulerTypeIdentifier
            
            JSCOperationCoordinator.sharedInstance.addOperation(operation)
        }
        else {
            
            myFailure?(error: nil,
                       postId: post.postId!)
        }
    }
}