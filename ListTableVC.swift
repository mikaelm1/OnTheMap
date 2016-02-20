//
//  ListTableVC.swift
//  OnTheMap
//
//  Created by Mikael Mukhsikaroyan on 2/15/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit

class ListTableVC: UITableViewController {
    
    var locations: [[String: AnyObject]]!
    var students = [Student]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
 
        ParseClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            if let students = result {
                self.students = students
                performUIUpdatesOnMain({ () -> Void in
                    self.tableView.reloadData()
                })
            } else {
                print(error)
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("cellForRowAtIndexPath")
        if students.count > 0 {
            let student = students[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("PinCell") as UITableViewCell!
            cell.textLabel!.text = "\(student.firstName) \(student.lastName)"
            cell.detailTextLabel?.text = "\(student.mediaUrl)"
            
            return cell
        }
        return UITableViewCell()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let student = students[indexPath.row]
        
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: student.mediaUrl)!)
        
    }

    @IBAction func postInfoPressed(sender: AnyObject) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("InformationPostingVC") as UIViewController!
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func refreshPressed(sender: AnyObject) {
        print("Refresh Pressed")
    }
    

}
