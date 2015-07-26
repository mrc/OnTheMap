//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Matt Curtis on 16/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import Foundation
import Deferred
import Result
import MapKit

class ParseClient: RESTClient {

    /**
        Return a list of student locations (deferred,
        may be an error result.)
    */
    func getStudentLocations() -> Deferred<Result<[StudentInformation]>> {

        let headers = [
            "Accept": "application/json",
            "X-Parse-Application-Id":"QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"]

        // helper to extract results and generate a list of locations
        // (if possible, otherwise return an error.)
        func resultsToStudentLocations(response: JSON) -> Result<[StudentInformation]> {
            if let results = response["results"] as? [JSON] {
                let locations = results.map {
                    StudentInformation(json: $0)
                }
                return Result(success: locations)
            } else {
                return Result(failure: "Unable to extract list of student locations.")
            }
        }

        return
            getJSONFrom("https://api.parse.com/1/classes/StudentLocation",
            withHeaders: headers)
                .map { $0.bind(resultsToStudentLocations) }
    }

    /**
        Post a new student location.
    */
    func postLocationFor(key: String, firstName: String, lastName: String, url: String, andLocation location: CLLocationCoordinate2D, named name: String) -> Deferred<Result<Void>> {

        let body: JSON = [
            "uniqueKey": key,
            "firstName": firstName,
            "lastName": lastName,
            "mapString": name,
            "mediaURL": url,
            "latitude": (Double)(location.latitude),
            "longitude": (Double)(location.longitude)]

        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "X-Parse-Application-Id":"QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"]

        return
            postWithJSONResultTo("https://api.parse.com/1/classes/StudentLocation",
                withBody: body, andHeaders: headers)
                .map {
                    switch $0 {
                    case let .Success(response):
                        if let reason = response.value["error"] as? String {
                            return Result(failure: reason)
                        }
                        return Result(success: ())

                    case let .Failure(reason):
                        return Result(failure: reason)
                    }
        }
    }
}
