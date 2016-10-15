//
//  ShowAPIManager.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 12/03/2016.
//
//

import Foundation
import EasyDownloadSession
import CoreDataServices

/**
 Manages the api calls to interact with Shows.
 */
class ShowAPIManager: NSObject {
    
    /**
     Creates and queues an operation for retrieving a Show.
     
     - Parameter showName: Name of the show to parse.
     - Parameter success: callback if the request is successful.
     - Parameter failure: callback if the request fails.
     */
    class func retrieveShow(showName: String, success: OperationOnSuccessCallback?, failure: OperationOnFailureCallback?) {
        
        DLog("Queuing request to insert a show")
        
        let request = ShowRequest.requestToRetrieveShow(showName)
        
        DownloadSession.scheduleDownloadWithId("retrieveShow-\(showName)",
                                               request: request,
                                               stackIdentifier: kTVRApiDownloadStack,
                                               progress: nil,
                                               success: { (taskInfo: DownloadTaskInfo!, responseData: NSData?) -> Void in
                                                
                                                let operation = ShowParsingOperation.init(showName: showName, data: responseData)
                                                
                                                operation.onSuccess = success
                                                operation.onFailure = failure
                                                
                                                operation.targetSchedulerIdentifier = kTVRLocalDataOperationSchedulerTypeIdentifier;
                                                
                                                OperationCoordinator.sharedInstance.addOperation(operation)
                                                
            },
                                               failure: { (taskInfo: DownloadTaskInfo!, error: NSError?) -> Void in
                                                
                                                if let failure: OperationOnFailureCallback = failure {
                                                    
                                                    failure(error)
                                                }
        })
    }
}
