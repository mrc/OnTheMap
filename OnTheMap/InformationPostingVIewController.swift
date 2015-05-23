//
//  InformationPostingVIewController.swift
//  OnTheMap
//
//  Created by Matt Curtis on 23/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import UIKit

class InformationPostingVIewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!

    @IBAction func findOnTheMapClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // allow the return key to hide the keyboard
        locationTextField.resignFirstResponder()
        return true
    }
}
