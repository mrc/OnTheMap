//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Matt Curtis on 23/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import UIKit
import MapKit
import Result
import Deferred

class InformationPostingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var locationInputTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var whereAreYouStudyingView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var selectedUserLocation: CLLocationCoordinate2D?
    var url: String?

    @IBAction func findOnTheMapClicked(sender: AnyObject) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut,
            animations: {
                self.whereAreYouStudyingView.alpha = 0
                self.locationInputTopConstraint.constant = 0
                self.submitButton.alpha = 1
                self.view.layoutIfNeeded()
            },
            completion: { ok in
                self.findLocation(self.locationTextField.text)
        })
    }

    @IBAction func submitLocationClicked(sender: AnyObject) {

        var alert = UIAlertController(title: "Almost there...", message: "Enter your link", preferredStyle: .Alert)

        let urlAction = UIAlertAction(title: "Submit", style: .Default) { _ in

            // save the text field for the presenting view controller
            let urlField = alert.textFields![0] as! UITextField
            self.url = urlField.text

            // dismiss the information posting view controller
            self.performSegueWithIdentifier("submitLocationSegue", sender: self)
        }

        urlAction.enabled = false // will be enabled when the user types something into the field

        alert.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Enter your URL"
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { notification in
                urlAction.enabled = true
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

        alert.addAction(urlAction)
        alert.addAction(cancelAction)

        self.presentViewController(alert, animated: true, completion: nil)

    }

    func showErrorMessage(message: String) {
        var errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(errorAlert, animated: true, completion: nil)
    }

    func showOnTheMap(item: MKMapItem) {
        if let region = item.placemark.region as? CLCircularRegion {
            self.selectedUserLocation = region.center

            let region = MKCoordinateRegionMakeWithDistance(region.center, region.radius, region.radius)
            mapView.setRegion(region, animated: true)

            let pin = StudentLocationPin(coordinate: region.center, title: item.placemark.name, subtitle: "")
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(pin)
        }
    }

    func findLocation(locationName: String) {

        // helper to return the list of MKMapItems
        // (if possible, otherwise return an error.)
        func searchResultsToMapItems(results: MKLocalSearchResponse) -> Result<[MKMapItem]> {
            if let items = results.mapItems as? [MKMapItem] {
                return Result(success: items)
            }
            else {
                return Result(failure: "No map items found.")
            }
        }

        let foundLocations = LocationSearch()
            .findLocationByName(locationName, inRegion: self.mapView.region)
            .map { $0.bind(searchResultsToMapItems) }
            .map { $0.bind(firstItem) }

        foundLocations
            .uponQueue(dispatch_get_main_queue()) {
                switch $0 {
                case .Success(let mapItem):
                    self.showOnTheMap(mapItem.value)
                    println("found: \(mapItem.value)")
                    break

                case .Failure(let error):
                    self.showErrorMessage("Unable to find location.")
                    break
                }
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // allow the return key to hide the keyboard
        locationTextField.resignFirstResponder()
        return true
    }
}
