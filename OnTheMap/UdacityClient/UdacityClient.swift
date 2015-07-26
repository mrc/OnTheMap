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

    struct UserInformation {
        var userId: String
        var firstName: String
        var lastName: String
    }

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
        Log out of the session.
    */
    func logOut() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
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

    /**
        Retrieve the user information from Udacity (deferred,
        might be an error result.)
    */
    func getUserInformation(userId: String) -> Deferred<Result<UserInformation>> {

        // helper to extract the user info from the JSON (if it exists)
        func infoFromResponse(response: JSON) -> Result<UserInformation> {
            if let
                key = response["user"]?["key"] as? String,
                firstName = response["user"]?["first_name"] as? String,
                lastName = response["user"]?["last_name"] as? String {

                let info = UserInformation(userId: key, firstName: firstName, lastName: lastName)
                return Result(success: info)
            } else {
                return Result(failure: "Unable to find user info.")
            }
        }

        return
            getUserData(userId)
                .map { $0.bind(infoFromResponse) }
    }
}
