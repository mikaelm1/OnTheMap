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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        ParseClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            
            if let students = result {
                self.students = students
                performUIUpdatesOnMain({ () -> Void in
                    self.pinLocations(students)
                })
                
            } else {
                print(error)
            }
        }
    }
    

    
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


    @IBAction func postInfoPressed(sender: AnyObject) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("InformationPostingVC") as UIViewController!
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func refreshPressed(sender: AnyObject) {
        //getStudentLocations()
    }

}
