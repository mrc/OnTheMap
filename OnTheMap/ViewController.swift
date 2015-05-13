//
//  ViewController.swift
//  OnTheMap
//
//  Created by Matt Curtis on 13/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import UIKit
import Deferred
import Result

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let d = Deferred<Result<String>>()
        d.upon { s in println("got \(s)") }
        d.fill(Result(success: "Hello"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

