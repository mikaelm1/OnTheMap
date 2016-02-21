//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Mikael Mukhsikaroyan on 2/20/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import Foundation

class UdacityClient {
    
    var session = NSURLSession.sharedSession()
    
    func getSession(username: String, password: String, completionHandlerForLogin: (success: Bool, error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForLogin(success: false, error: NSError(domain: "getSession", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("\(error)")
                return
            }
            
            guard let data = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5)) else {
                print("NO data was returned by the request")
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON")
                return
            }
            
            guard let confirmation = parsedResult["account"] as? [String: AnyObject] else {
                sendError("Not registered")
                return
            }
            //print(confirmation)
            
            guard let userId = confirmation["key"] as? String else {
                sendError("Could not get user ID")
                return
            }
            //print(userId)
            
            Constants.userId = userId
            completionHandlerForLogin(success: true, error: nil)
            
            // end of closure
        }
        task.resume()
        
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}







