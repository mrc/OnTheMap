//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Matt Curtis on 21/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: StudentLocationsViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func loadedLocations(locations: [StudentInformation]) {
        super.loadedLocations(locations)

        // clear existing annotations
        mapView.removeAnnotations(mapView.annotations)

        // add new annotations
        for loc in locations {
            if let
                firstName = loc.firstName,
                lastName = loc.lastName,
                latitude = loc.latitude,
                longitude = loc.longitude,
                url = loc.mediaURL {
                    let coords = CLLocationCoordinate2DMake(latitude, longitude)
                    let title = "\(firstName) \(lastName)"
                    let pin = StudentLocationPin(coordinate: coords, title: title, subtitle: url)
                    mapView.addAnnotation(pin)
            }
        }
    }

}
