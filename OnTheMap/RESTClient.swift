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

    func postTo(method: String, withBody: JSON) -> Deferred<Result<NSData>> {

        let d = Deferred<Result<NSData>>()

        let request = NSMutableURLRequest(URL: NSURL(string: method)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        var jsonifyError: NSError? = nil
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(withBody, options: nil, error: &jsonifyError)
        if let error = jsonifyError {
            d.fill(Result(failure: "converting body: \(error.description)"))
        }

        let task = urlSession.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                d.fill(Result(failure: error.description))
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                println(NSString(data: newData, encoding: NSUTF8StringEncoding))
                d.fill(Result(success: newData))
            }
        }
        task.resume()
        return d
    }

    func getFrom(method: String) -> Deferred<Result<NSData>> {

        let d = Deferred<Result<NSData>>()

        let request = NSMutableURLRequest(URL: NSURL(string: method)!)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = urlSession.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                d.fill(Result(failure: error.description))
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                println(NSString(data: newData, encoding: NSUTF8StringEncoding))
                d.fill(Result(success: newData))
            }
        }
        task.resume()
        return d
    }
}