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
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingViewMessage: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

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

    override func viewDidAppear(animated: Bool) {
        populateStudentLocations()
    }

    func populateStudentLocations() {

        if self.isUpdating {
            // Don't reload while already loading
            return
        }

        let hiddenY = CGFloat(-64) // hidden above the view
        let targetY =  CGFloat(64) // just below the navigation bar

        // Prevent recursive reloading
        self.isUpdating = true

        // Show a loading message
        let steelBlue4 = UIColor(red: CGFloat(74.0/255.0), green: CGFloat(112.0/255.0), blue: CGFloat(119.0/255.0), alpha: 1.0)
        self.loadingView.backgroundColor = steelBlue4
        self.loadingView.frame.origin.y = hiddenY
        self.loadingViewMessage.text = "Loading student locations..."
        self.loadingView.hidden = false
        let doneAnimating = Deferred<Bool>()
        UIView.animateWithDuration(0.4, delay: 0.0,
            usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn,
            animations: { self.loadingView.frame.origin.y = targetY },
            completion: { finished in doneAnimating.fill(finished) })

        self.activityIndicator.hidden = false
        activityIndicator.startAnimating()

        let parseClient = ParseClient()
        parseClient
            .getStudentLocations()
            .uponQueue(dispatch_get_main_queue()) {
                var disappearDuration = 1.0
                var disappearDelay = 0.0

                switch $0 {
                case let .Success(locations):
                    self.loadedLocations(locations.value)

                case let .Failure(error):
                    self.loadingView.backgroundColor = .redColor()
                    disappearDelay = 5.0
                    self.loadingViewMessage.text = error.description
                    println("error: \(error)")
                }

                // Move the loading message off the screen,
                // and allow reloading.
                doneAnimating.uponQueue(dispatch_get_main_queue()) { finished in
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    UIView.animateWithDuration(disappearDuration, delay: disappearDelay,
                        usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,
                        options: .CurveEaseOut,
                        animations: { self.loadingView.frame.origin.y = hiddenY },
                        completion: { ok in
                            self.isUpdating = false
                            self.loadingView.hidden = true
                    })
                }
        }
    }

}