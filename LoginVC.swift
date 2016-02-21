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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = "mm132017@yahoo.com"
        passwordTextField.text = "Viking27"

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
                } else {
                    performUIUpdatesOnMain({ () -> Void in
                        self.setUIEnabled(true)
                        self.sendAlert("Invalid username or password")
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
    
    
    private func completeLogin() {
        setUIEnabled(true)
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("OTMTabController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
        
    }
  

}















