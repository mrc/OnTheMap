//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Matt Curtis on 16/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import Foundation
import MapKit

class StudentLocation {

    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?

    init(json: JSON) {
        firstName = json["firstName"] as? String
        lastName = json["lastName"] as? String
        latitude = (json["latitude"] as? Double)
        longitude = (json["longitude"] as? Double)
        mapString = json["mapString"] as? String
        mediaURL = json["mediaURL"] as? String
    }
}