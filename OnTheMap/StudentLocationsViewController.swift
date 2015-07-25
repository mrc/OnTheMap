//
//  StudentLocationsViewController.swift
//  OnTheMap
//
//  Created by Matt Curtis on 24/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import UIKit
import Deferred

class StudentLocationsViewController: UIViewController {

    @IBOutlet weak var dropPinButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingViewTopConstraint: NSLayoutConstraint!

    var isUpdating = false

    func loadedLocations(locations: [StudentLocation]) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a refresh button (because we can't add buttons programatically)
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "populateStudentLocations")
        refreshButton.tintColor = .blackColor()

        navigationItem.rightBarButtonItems = [refreshButton, dropPinButton]
    }

    override func viewWillAppear(animated: Bool) {
        self.loadingViewTopConstraint.constant = -128
    }

    override func viewDidAppear(animated: Bool) {
        populateStudentLocations()
    }

    func showLoadingMessage() {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()

        UIView.animateWithDuration(0.4, delay: 0.0,
            usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0,
            options: .CurveEaseIn,
            animations: {
                self.loadingViewTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            },
            completion: { ok in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                UIView.animateWithDuration(0.4, delay: 2.0,
                    usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0,
                    options: .CurveEaseOut,
                    animations: {
                        self.loadingViewTopConstraint.constant = -128
                        self.view.layoutIfNeeded()
                    },
                    completion: nil)
        })
    }

    func showErrorMessage(message: String) {
        var errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(errorAlert, animated: true, completion: nil)
    }

    func populateStudentLocations() {

        if self.isUpdating {
            // Don't reload while already loading
            return
        }

        // Prevent recursive reloading
        self.isUpdating = true

        // Show a loading message
        showLoadingMessage()

        let parseClient = ParseClient()
        parseClient
            .getStudentLocations()
            .uponQueue(dispatch_get_main_queue()) {

                switch $0 {
                case let .Success(locations):
                    self.loadedLocations(locations.value)
                    self.isUpdating = false

                case let .Failure(error):
                    self.showErrorMessage(error.description)
                }
        }
    }


    @IBAction func submitLocation(segue: UIStoryboardSegue) {
        if let
            vc = segue.sourceViewController as? InformationPostingViewController,
            location = vc.selectedUserLocation,
            url = vc.url {
                println("found location \(location), url \(url)")
        }
    }

    @IBAction func cancelLocationSubmit(segue: UIStoryboardSegue) {

    }


}