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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        promptLabel.text = "Where are you\n studying\n today?"
        UdacityClient.sharedInstance().getUserData()
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
            
            User.mapString = self.locationTextField.text
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = self.locationTextField.text
            User.latitude = response!.boundingRegion.center.latitude
            User.longitude = response!.boundingRegion.center.longitude
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(User.latitude, User.longitude)
            
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
        User.mediaUrl = webAdressField.text!
        ParseClient.sharedInstance().postStudentLocation { (success) -> Void in
            print("Submitted")
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
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
