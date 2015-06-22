//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Matt Curtis on 21/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import UIKit
import MapKit
import Result

class MapViewController: StudentLocationsViewController {

    @IBOutlet weak var mapView: MKMapView!

    @IBAction func dropPinButtonClicked(sender: AnyObject) {
        println("poink!")
    }

    override func loadedLocations(locations: [StudentLocation]) {
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

    @IBAction func findOnTheMap(segue:UIStoryboardSegue) {

        if let vc = segue.sourceViewController as? InformationPostingViewController {

            // helper to return the list of MKMapItems
            // (if possible, otherwise return an error.)
            func resultsToMapItems(results: MKLocalSearchResponse) -> Result<[MKMapItem]> {
                if let items = results.mapItems as? [MKMapItem] {
                    return Result(success: items)
                }
                else {
                    return Result(failure: "No map items found.")
                }
            }

            let foundLocations = LocationSearch()
                .findLocationByName(vc.locationTextField.text, inRegion: self.mapView.region)
                .map { $0.bind(resultsToMapItems) }

            foundLocations
                .uponQueue(dispatch_get_main_queue()) {
                    switch $0 {
                    case .Success(let mapItems):
                        println("found: \(mapItems)")
                        break

                    case .Failure(let error):
                        println("error: \(error))")
                        break
                    }
            }

        }
    }

}
