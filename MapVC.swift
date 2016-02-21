//
//  MapVC.swift
//  OnTheMap
//
//  Created by Mikael Mukhsikaroyan on 2/14/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        loadStudents()
    }
    
    private func setupButtons() {
        let logoutButton = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logout")
        parentViewController?.navigationItem.leftBarButtonItem = logoutButton
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshButtonPressed")
        let postInfoButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: "postInfoButtonPressed")
        parentViewController?.navigationItem.setRightBarButtonItems([refreshButton, postInfoButton], animated: true)
    }
    
    func logout() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshButtonPressed() {
        loadStudents()
    }
    
    func postInfoButtonPressed() {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("InformationPostingVC") as UIViewController!
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func loadStudents() {
        
        activityIndicator.alpha = 1.0
        activityIndicator.startAnimating()
        mapView.alpha = 0.5
        ParseClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            
            if let students = result {
                self.students = students
                performUIUpdatesOnMain({ () -> Void in
                    self.pinLocations(students)
                })
                
            } else {
                self.sendAlert(error!)
            }
        }
        activityIndicator.alpha = 0.0
        activityIndicator.stopAnimating()
        mapView.alpha = 1.0
    }
    
    private func sendAlert(message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: Map methods
    
    private func pinLocations(students: [Student]) {
        
        var annotations = [MKPointAnnotation]()
        
        for student in students {
            
            let coordinate = CLLocationCoordinate2DMake(student.latitude, student.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaUrl
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
        
    }
        
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        //print("viewForAnnotation")
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.redColor()
            pinView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: view.annotation!.subtitle!!)!)
        }
        
    }


}
