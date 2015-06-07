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

class ParseClient: RESTClient {

    /**
        Return a list of student locations (deferred,
        may be an error result.)
    */
    func getStudentLocations() -> Deferred<Result<[StudentLocation]>> {

        let headers = [
            "Accept": "application/json",
            "X-Parse-Application-Id":"QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"]

        // helper to extract results and generate a list of locations
        // (if possible, otherwise return an error.)
        func resultsToStudentLocations(response: JSON) -> Result<[StudentLocation]> {
            if let results = response["results"] as? [JSON] {
                let locations = results.map {
                    StudentLocation(json: $0)
                }
                return Result(success: locations)
            } else {
                return Result(failure: "Unable to extract list of student locations.")
            }
        }

        return
            getFrom("https://api.parse.com/1/classes/StudentLocation",
            withHeaders: headers)
                .map { $0.bind(NSData.toJSON) }
                .map { $0.bind(resultsToStudentLocations) }
    }
}