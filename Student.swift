//
//  Student.swift
//  OnTheMap
//
//  Created by Mikael Mukhsikaroyan on 2/19/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit

struct Student {
    
    let firstName: String
    let lastName: String
    let mediaUrl: String
    let latitude: Double
    let longitude: Double
    
    init(result: [String: AnyObject]) {
        firstName = result["firstName"] as! String
        lastName = result["lastName"] as! String
        latitude = result["latitude"] as! Double
        longitude = result["longitude"] as! Double
        
        if let url = result["mediaURL"] as? String where !url.isEmpty {
            mediaUrl = url
        } else {
            mediaUrl = "google.com"
        }
    }
    
    static func studentsFromResults(results: [[String: AnyObject]]) -> [Student] {
        var students = [Student]()
        
        for result in results {
            students.append(Student(result: result))
        }
        return students 
    }
    
}







