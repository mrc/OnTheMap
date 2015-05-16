//
//  ResultT.swift
//  OnTheMap
//
//  Created by Matt Curtis on 14/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import Foundation
import Deferred
import Result

extension Result {

    /**
        Unwrap a Result and, if it's a success,
        continue with the function "f", otherwise
        propagate the failure.
    */
    func toDeferred<U>(f: T -> Deferred<Result<U>>)
        -> Deferred<Result<U>> {
            switch self {
            case let .Success(value):
                return f(value.value)
            case let .Failure(e):
                return Deferred(value: .Failure(e))
            }
    }

}
