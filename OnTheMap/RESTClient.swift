//
//  RESTClient.swift
//  OnTheMap
//
//  Created by Matt Curtis on 16/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import Foundation
import Result
import Deferred

class RESTClient {

    lazy var urlSession = NSURLSession.sharedSession()

    /**
        POST some JSON data to a URL, and return the deferred
        result, either the NSData retrieved from the URL,
        or the error that occurred while POSTing.
    */
    func postTo(method: String, withBody: JSON, andHeaders: [String: String]) -> Deferred<Result<NSData>> {

        let d = Deferred<Result<NSData>>()

        let request = NSMutableURLRequest(URL: NSURL(string: method)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for (field, value) in andHeaders {
            request.addValue(value, forHTTPHeaderField: field)
        }

        var jsonifyError: NSError? = nil
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(withBody, options: nil, error: &jsonifyError)
        if let error = jsonifyError {
            d.fill(Result(failure: "converting body: \(error.description)"))
        }

        let task = urlSession.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                d.fill(Result(failure: error.description))
            } else {
                d.fill(Result(success: data))
            }
        }
        task.resume()
        return d
    }

    /**
        POST some JSON data to a URL, and return the deferred
        result, either the JSON retrieved from the URL,
        or the error that occurred while POSTing.
    */
    func postWithJSONResultTo(method: String, withBody: JSON, andHeaders: [String: String]) -> Deferred<Result<JSON>> {
        return postTo(method, withBody: withBody, andHeaders: andHeaders)
            .map { $0.bind(NSData.toJSON) }
    }

    /**
        GET from a URL, and return the deferred result, either
        the NSData retrieved from the URL, or the error that
        occurred while GETting.
    */
    func getFrom(method: String, withHeaders: [String: String]) -> Deferred<Result<NSData>> {

        let d = Deferred<Result<NSData>>()

        let request = NSMutableURLRequest(URL: NSURL(string: method)!)
        request.HTTPMethod = "GET"

        for (field, value) in withHeaders {
            request.addValue(value, forHTTPHeaderField: field)
        }

        let task = urlSession.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                d.fill(Result(failure: error.description))
            } else {
                d.fill(Result(success: data))
            }
        }
        task.resume()
        return d
    }

    /**
        GET from a URL, and return the deferred result, either
        the JSON retrieved from the URL, or the error that
        occurred while GETting.
    */
    func getJSONFrom(method: String, withHeaders: [String: String]) -> Deferred<Result<JSON>> {
        return getFrom(method, withHeaders: withHeaders)
            .map { $0.bind(NSData.toJSON) }
    }

}