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

    func getUserId(username: String, password: String) -> Deferred<Result<String>> {

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

    func createSession(username: String, password: String) -> Deferred<Result<JSON>> {

        let body = ["udacity": [
            "username": username,
            "password": password]]

        func NSDataToJSON(data: NSData) -> Result<JSON> {
            return data.toJSON()
        }

        return
            postTo("https://www.udacity.com/api/session", withBody: body)
                .map { $0.bind(NSData.toJSON) }
    }

    func getUserData(userId: String) -> Deferred<Result<JSON>> {
        return
            getFrom("https://www.udacity.com/api/users/\(userId)")
                .map { $0.bind(NSData.toJSON) }
    }
}
