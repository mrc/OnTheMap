//
//  StudentLocationPin.swift
//  OnTheMap
//
//  Created by Matt Curtis on 23/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import MapKit

class StudentLocationPin: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
