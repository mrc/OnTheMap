//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Matt Curtis on 21/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: StudentLocationsViewController, MKMapViewDelegate {

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
                    pin
                    mapView.addAnnotation(pin)
            }
        }
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {

        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIView
        return view
    }

    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {

        if let urlString = view.annotation.subtitle,
            url = NSURL(string: urlString)
            where UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
        }
    }

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {

    }

}
