//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Matt Curtis on 14/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import Foundation
import Deferred
import Result

class UdacityClient: RESTClient {

    /**
        Log in to Udacity and retrieve the user ID
        (deferred, might be an error result.)
    */
    func getUserId(username: String, password: String) -> Deferred<Result<String>> {

        // helper to extract the key (user ID) from the JSON (if it exists)
        func keyFromResponse(response: JSON) -> Result<String> {
            if let key = response["account"]?["key"] as? String {
                return Result(success: key)
            } else {
                return Result(failure: "No key found in response.")
            }
        }

        return
            createSession(username, password: password)
                .map { $0.bind(keyFromResponse) }
    }

    /**
        Remove the security header from the Udacity server responses.
    */
    static func dropSecurityHeader(data: NSData) -> NSData {
        // the first 5 bytes are the Udacity "security header"
        return data.subdataWithRange(NSMakeRange(5, data.length - 5))
    }

    /**
        Create a session with Udacity, and return the
        JSON result (deferred, might be an error result.)
    */
    func createSession(username: String, password: String) -> Deferred<Result<JSON>> {

        let body = ["udacity": [
            "username": username,
            "password": password]]

        let headers = ["Accept": "application/json"]

        return
            postTo("https://www.udacity.com/api/session", withBody: body, andHeaders: headers)
                .map { $0.map(UdacityClient.dropSecurityHeader) }
                .map { $0.bind(NSData.toJSON) }
    }

    /**
        Retrieve the data for a user from Udacity, as a JSON
        result (deferred, might be an error result.)
    */
    func getUserData(userId: String) -> Deferred<Result<JSON>> {
        let headers = ["Accept": "application/json"]

        return
            getFrom("https://www.udacity.com/api/users/\(userId)", withHeaders: headers)
                .map { $0.map(UdacityClient.dropSecurityHeader) }
                .map { $0.bind(NSData.toJSON) }
    }
}
