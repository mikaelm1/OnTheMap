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
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func signUpPressed(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: Constants.Udacity.signUpPage)!)
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            sendAlert("Blank username or password")
        } else {
            setUIEnabled(false)
            let password = passwordTextField.text!
            let username = usernameTextField.text!
            UdacityClient.sharedInstance().getSession(username, password: password, completionHandlerForLogin: { (success, error) -> Void in
                if success {
                    performUIUpdatesOnMain({ () -> Void in
                        self.completeLogin()
                    })
                } else if error == "The Internet connection appears to be offline." {
                    performUIUpdatesOnMain({ () -> Void in
                        self.setUIEnabled(true)
                        self.sendAlert(error!)
                    })
                    
                }else {
                    performUIUpdatesOnMain({ () -> Void in
                        self.setUIEnabled(true)
                        self.sendAlert("Invalid password or username")
                    })
                    
                }
            })
        }
    }
    
    private func sendAlert(message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }
    
    private func setUIEnabled(enabled: Bool) {
        loginButton.enabled = enabled
        usernameTextField.enabled = enabled
        passwordTextField.enabled = enabled
        signUpButton.enabled = enabled
        signUpLabel.enabled = enabled
        
        if enabled {
            loginButton.alpha = 1.0
            usernameTextField.alpha = 1.0
            passwordTextField.alpha = 1.0
            signUpLabel.alpha = 1.0
            signUpButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
            usernameTextField.alpha = 0.5
            passwordTextField.alpha = 0.5
            signUpLabel.alpha = 0.5
            signUpButton.alpha = 0.5
        }
    }
    
    
    private func completeLogin() {
        passwordTextField.text = ""
        setUIEnabled(true)
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("OTMTabController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
        
    }
  

}















