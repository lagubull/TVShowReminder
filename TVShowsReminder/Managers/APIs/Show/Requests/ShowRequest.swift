//
//  ShowRequest.swift
//  TVShowsReminder
//
//  Created by Javier Laguna on 10/03/2016.
//
//

import Foundation

/**
HTTP GET Method.
*/
let kHTTPRequestMethodGet = "GET" as String!

/**
 API end point URL.
 */
let kApiEndPoint = "http://epguides.com/"

/**
Request to retrieve a feed.
*/
class ShowRequest: NSMutableURLRequest {

    //MARK: Retrieve
    
    /**
    Creates a request for downloading a page of content.

    - Parameter showName: showName to download the content from.
    
    - Returns: an instance of the class.
    */
    class func requestToRetrieveShow(showName: String) -> ShowRequest {
    
        let request = self.init() as ShowRequest
        
        request.HTTPMethod = kHTTPRequestMethodGet
        
        request.URL = NSURL.init(string: "\(kApiEndPoint)/\(showName)")
        
        return request
    }
}