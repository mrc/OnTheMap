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

    @IBOutlet weak var debugLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let d = Deferred<Result<String>>()
        d
            .bind { $0.toDeferred(self.updateLabel) }
            .bind { $0.toDeferred(self.updateLabel2) }
            .map { _ in 100 }
            .upon { println("finally: \($0)") }
        d.fill(Result(success: "Hello"))

        let client = UdacityClient()
        let username = "USERNAME"
        let password = "PASSWORD"
        client.getUserId(username, password: password)
            .uponQueue(dispatch_get_main_queue()) {
                self.debugLabel.text = "userid: \($0)"
                println("userid: \($0)")
        }
    }

    func updateLabel(s: String) -> Deferred<Result<Int>> {
        dispatch_async(dispatch_get_main_queue()) {
            self.debugLabel.text = "\(s)"
        }

        let d = Deferred<Result<Int>>()
        d.fill(Result(success: 23))
        return d
    }
    func updateLabel2(s: Int) -> Deferred<Result<Int>> {
        dispatch_async(dispatch_get_main_queue()) {
            println("update2: \(s)")
        }

        let d = Deferred<Result<Int>>()
        d.fill(Result(success: 23))
        return d
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
