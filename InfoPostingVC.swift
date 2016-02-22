//
//  InfoPostingVC.swift
//  OnTheMap
//
//  Created by Mikael Mukhsikaroyan on 2/22/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import MapKit 

class InfoPostingVC: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var webLinkField: UITextField!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    let blue = UIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1.0)
    let silver = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
    
    let linkPlaceholder = "Enter a link to Share Here"
    let promptText = "Where are you\n studying\n today?"
    let locationPlaceholder = "Enter location"
    var state = "Location"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationField.delegate = self
        webLinkField.delegate = self 

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        doInitialSetUp()
        setupUIForState()
    }
    
    func doInitialSetUp() {
        promptLabel.text = promptText
        locationField.text = locationPlaceholder
        locationField.tag = 0
        webLinkField.text = linkPlaceholder
        webLinkField.tag = 1
        
        topView.backgroundColor = silver
        middleView.backgroundColor = blue
        bottomView.backgroundColor = silver
        webLinkField.backgroundColor = blue
        
        findLocationButton.layer.cornerRadius = 5
        findLocationButton.clipsToBounds = true
        
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
        
        activityIndicator.alpha = 0.0
        
        UdacityClient.sharedInstance().getUserData()
    }
    
    func setupUIForState() {
        if state == "Location" {
            topView.hidden = false
            middleView.hidden = false
            bottomView.hidden = false
            mapView.hidden = true
            promptLabel.hidden = false
            findLocationButton.hidden = false
            findLocationButton.enabled = true
            cancelButton.tintColor = blue
            submitButton.enabled = false
            submitButton.hidden = true
            webLinkField.hidden = true
            webLinkField.enabled = false
        } else if state == "Map" {
            mapView.hidden = false
            topView.backgroundColor = blue
            cancelButton.tintColor = UIColor.whiteColor()
            middleView.hidden = true
            bottomView.hidden = true
            findLocationButton.hidden = true
            findLocationButton.enabled = false
            submitButton.enabled = true
            submitButton.hidden = false
            webLinkField.enabled = true
            webLinkField.hidden = false
            promptLabel.hidden = true 
        }
    }
    
    func sendAlert(message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }
    

    @IBAction func submitEntryPressed(sender: AnyObject) {
        if webLinkField.text == "" || webLinkField.text == linkPlaceholder {
            sendAlert("Please enter a link to share")
        } else {
            User.mediaUrl = webLinkField.text!
            ParseClient.sharedInstance().postStudentLocation { (success) -> Void in
                print("Submitted")
                if success {
                    self.state = "Location"
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.sendAlert("Failed to post location")
                }
            }
        }
    }
    
    @IBAction func findLocationPressed(sender: AnyObject) {
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1.0
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = locationField.text
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (response, error) -> Void in
            
            if response == nil {
                self.sendAlert("Location Not Found")
                return
            }
            
            User.mapString = self.locationField.text!
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = self.locationField.text
            User.latitude = response!.boundingRegion.center.latitude
            User.longitude = response!.boundingRegion.center.longitude
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(User.latitude, User.longitude)
            
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = pointAnnotation.coordinate
            self.mapView.addAnnotation(pinAnnotationView.annotation!)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: response!.boundingRegion.center, span: span)
            self.mapView.setRegion(region, animated: true)
            
            
            self.state = "Map"
            self.setupUIForState()
            performUIUpdatesOnMain({ () -> Void in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.alpha = 0.0
            })
            
            
            // end of closure
        }

    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        state = "Location"
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: TextField
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
        textField.textAlignment = .Center
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 0 && textField.text == "" {
            textField.textAlignment = .Left
            textField.text = locationPlaceholder
        } else if textField.tag == 1 && textField.text == "" {
            textField.text = linkPlaceholder
        }
    }


}
