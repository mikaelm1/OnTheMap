//
//  InformationPostingVC.swift
//  OnTheMap
//
//  Created by Mikael Mukhsikaroyan on 2/16/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import MapKit 

class InformationPostingVC: UIViewController {


    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var webAdressField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextView!
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var mapString: String?
    var firstName: String?
    var lastName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getUserData() // For testing, Delete WHEN FINISHED
        promptLabel.text = "Where are you\n studying\n today?"
    }
    
    
    @IBAction func findLocationPressed(sender: AnyObject) {
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = locationTextField.text
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (response, error) -> Void in
            
            if response == nil {
                let controller = UIAlertController(title: nil, message: "Location Not Found", preferredStyle: .Alert)
                controller.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                self.presentViewController(controller, animated: true, completion: nil)
                return
            }
            
            self.mapString = self.locationTextField.text
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = self.locationTextField.text
            self.latitude = response!.boundingRegion.center.latitude
            self.longitude = response!.boundingRegion.center.longitude
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.latitude!, self.longitude!)
            
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = pointAnnotation.coordinate
            self.mapView.addAnnotation(pinAnnotationView.annotation!)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: response!.boundingRegion.center, span: span)
            self.mapView.setRegion(region, animated: true)
            
            self.showMap()
            
        // end of closure
        }
    }
    
    @IBAction func submitLinkPressed(sender: AnyObject) {
        
        let mediaUrl = webAdressField.text!
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue(Constants.Parse.applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Parse.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(Constants.userId)\", \"firstName\": \"\(firstName!)\", \"lastName\": \"\(lastName!)\",\"mapString\": \"\(mapString!)\", \"mediaURL\": \"\(mediaUrl)\",\"latitude\": \(latitude!), \"longitude\": \(longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            guard (error == nil) else {
                print("There was an error with the request")
                return
            }
            
            guard let data = data else {
                print("Could not find any data")
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print("Could not parse into JSON")
                return
            }
            //print(parsedResult)
            
            // No error, so do something
            self.dismissViewControllerAnimated(true, completion: nil)
            
        // end of closure
        }
        task.resume()
    }
    
    private func getUserData() {
        let userId = Constants.userId
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userId)")!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            guard (error == nil) else {
                print("There was an error with your request")
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
            //print(parsedResult)
            
            guard let user = parsedResult["user"] as? [String:AnyObject] else {
                print("Could not find user data")
                return
            }
            //print(user)
            
            guard let lastName = user["last_name"] as? String, let firstName = user["first_name"] as? String else {
                print("Could not get last name")
                return
            }
            //print(lastName, firstName)
            self.lastName = lastName
            self.firstName = firstName
            
        // end of closure
        }
        task.resume()
        
    }
    
    private func showMap() {
        
        bottomView.hidden = true
        locationTextField.hidden = true
        promptLabel.hidden = true
        
        webAdressField.hidden = false
        webAdressField.enabled = true
        
        submitButton.enabled = true
        submitButton.hidden = false
        
        mapView.hidden = false
        
    }
    

}
