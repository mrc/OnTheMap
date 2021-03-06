//
//  ResultError.swift
//  OnTheMap
//
//  Created by Matt Curtis on 16/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import Foundation
import Result

/**
    Extend String to be an error type suitable for Result.
*/
extension String: ErrorType {
    public var description: String { return self }
}
