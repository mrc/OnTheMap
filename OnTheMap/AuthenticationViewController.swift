//
//  AuthenticationViewController.swift
//  OnTheMap
//
//  Created by Matt Curtis on 13/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var debugLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let parseClient = ParseClient()
        let sloc = parseClient.getStudentLocations()
        sloc.uponQueue(dispatch_get_main_queue()) {
            println("sloc: \($0)")
        }

        let udacityClient = UdacityClient()
        let username = "USERNAME"
        let password = "PASSWORD"
        udacityClient.getUserId(username, password: password)
            .uponQueue(dispatch_get_main_queue()) {
                self.debugLabel.text = "userid: \($0)"
                println("userid: \($0)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
