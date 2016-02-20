//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Mikael Mukhsikaroyan on 2/19/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import Foundation

class ParseClient {
    
    var session = NSURLSession.sharedSession()
    
    // getStudentLocations
    func getStudentLocations(completionHandlerForStudentLocations: (result: [Student]?, error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100")!)
        
        request.addValue(Constants.Parse.applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Parse.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        //let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            guard (error == nil) else {
                print("There was an error with the request")
                return
            }
            
            guard let data = data else {
                print("No data was returned")
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print("Unable to parse into JSON")
                return
            }
            //print(parsedResult)
            
            guard let locations = parsedResult["results"] as? [[String:AnyObject]] else {
                print("Unable to get the locations")
                return
            }
            //print(locations)
            
            let students = Student.studentsFromResults(locations)
            completionHandlerForStudentLocations(result: students, error: nil)
            
            //print(locations)
            performUIUpdatesOnMain({ () -> Void in
                // Set the student locations informations 
                //self.pinLocations(locations)
            })
            
            // end of closure
        }
        task.resume()
        
    }
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}
