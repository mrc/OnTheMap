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

    /**
        Parse this NSData as JSON, and return it
        or the error that occurred while parsing it.
    */
    func toJSON() -> Result<JSON> {

        var parsingError: NSError? = nil
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(self, options: .AllowFragments, error: &parsingError)

        if let error = parsingError {
            return Result(failure: "parsing result: \(error.description)")
        } else if let json = parsedResult as? JSON {
            return Result(success: json)
        } else {
            return Result(failure: "Unable to parse response as JSON.")
        }
    }

    /**
        Parse NSData as JSON, and return it
        or the error that occurred while parsing it.
    */
    static func toJSON(d: NSData) -> Result<JSON> {
        return d.toJSON()
    }

}

