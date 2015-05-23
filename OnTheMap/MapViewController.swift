//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Matt Curtis on 21/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import UIKit
import MapKit

class Pin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    override init() {
        coordinate = CLLocationCoordinate2D(latitude: -37.8253, longitude: 144.9839)
        title = "Riverside"
        subtitle = "AAMI Park"
    }
}

class MapViewController: UIViewController {

    @IBOutlet weak var dropPinButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a refresh button (because we can't add buttons programatically)
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshButtonClicked")
        refreshButton.tintColor = .blackColor()

        navigationItem.rightBarButtonItems = [refreshButton, dropPinButton]

        // experiment. add something to the map
        let pin = Pin()
        mapView.addAnnotation(pin)
    }

    func refreshButtonClicked() {
        println("refreshing!")
    }

    @IBAction func dropPinButtonClicked(sender: AnyObject) {
        println("poink!")
    }

}
