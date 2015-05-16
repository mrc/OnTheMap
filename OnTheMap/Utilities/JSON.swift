//
//  JSON.swift
//  OnTheMap
//
//  Created by Matt Curtis on 14/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import Foundation
import Result

typealias JSON = [String: AnyObject]

extension NSData {

    func toJSON() -> Result<JSON> {

        var parsingError: NSError? = nil
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(self, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)

        if let error = parsingError {
            return Result(failure: "parsing result: \(error.description)")
        } else if let json = parsedResult as? JSON {
            return Result(success: json)
        } else {
            return Result(failure: "Unable to parse response as JSON.")
        }
    }

    static func toJSON(d: NSData) -> Result<JSON> {
        return d.toJSON()
    }

}

