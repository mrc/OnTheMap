//
//  LocationSearch.swift
//  OnTheMap
//
//  Created by Matt Curtis on 21/06/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import MapKit
import Result
import Deferred

class LocationSearch {

    /**
        Perform a MKLocalSearchRequest, and return the deferred
        result, either the MKLocalSearchResponse result, or the
        error that occurred while searching.
    */
    func findLocationByName(locationName: String, inRegion: MKCoordinateRegion) -> Deferred<Result<MKLocalSearchResponse>> {

        // return a deferred result
        var d = Deferred<Result<MKLocalSearchResponse>>()

        // set up map search
        let lsr = MKLocalSearchRequest()
        lsr.naturalLanguageQuery = locationName
        lsr.region = inRegion
        let search = MKLocalSearch(request: lsr)

        // start search
        search.startWithCompletionHandler { (response, error) in
            if error != nil {
                d.fill(Result(failure: error.description))
            }
            else {
                d.fill(Result(success: response))
            }
        }

        return d
    }
}
