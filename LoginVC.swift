//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Mikael Mukhsikaroyan on 2/14/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = "mm132017@yahoo.com"
        passwordTextField.text = "Viking27"

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        debugLabel.text = ""
    }

    @IBAction func loginPressed(sender: AnyObject) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugLabel.text = "Username or Password left blank"
        } else {
            setUIEnabled(false)
            let password = passwordTextField.text!
            let username = usernameTextField.text!
            getSession(username, password: password)
        }
    }
    
    private func setUIEnabled(enabled: Bool) {
        loginButton.enabled = enabled
        usernameTextField.enabled = enabled
        passwordTextField.enabled = enabled
        
        if enabled {
            loginButton.alpha = 1.0
            usernameTextField.alpha = 1.0
            passwordTextField.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
            usernameTextField.alpha = 0.5
            passwordTextField.alpha = 0.5
        }
    }
    
    private func getSession(username: String, password: String) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
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
            
            guard let confirmation = parsedResult["account"] else {
                print("Not registered")
                return
            }
            
            guard let userId = confirmation!["key"] as? String else {
                print("Could not get user ID")
                return
            }
            //print(userId)
            
            Constants.userId = userId
            self.completeLogin()
            
        // end of closure
        }
        task.resume()
        
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain { () -> Void in
            self.debugLabel.text = ""
            self.setUIEnabled(true)
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("OTMTabController") as! UITabBarController 
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
  

}















