//
//  AuthenticationViewController.swift
//  OnTheMap
//
//  Created by Matt Curtis on 13/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import UIKit
import Deferred
import Result

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!

    func showErrorMessage(message: String) {
        var alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func loginButtonClicked(sender: AnyObject) {
        let udacityClient = UdacityClient()
        let username = emailTextField.text
        let password = passwordTextField.text

        loginActivityIndicator.startAnimating()

        udacityClient
            .getUserId(username, password: password)
            .bind { $0.toDeferred { udacityClient.getUserInformation($0) } }
            .uponQueue(dispatch_get_main_queue()) {

                self.loginActivityIndicator.stopAnimating()

                switch $0 {
                case let .Success(userInfo):

                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.udacityUserInformation = userInfo.value

                    self.performSegueWithIdentifier("segueAfterLogin", sender: self)

                case let .Failure(error):
                    self.showErrorMessage(error.description)
                }
        }
    }

    @IBAction func signUpButtonClicked(sender: AnyObject) {
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
