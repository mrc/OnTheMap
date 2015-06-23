//
//  ArrayExtensions.swift
//  OnTheMap
//
//  Created by Matt Curtis on 23/06/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import Result

/**
return the first item from a list
(if possible, otherwise return an error.)
*/
func firstItem<T>(items: [T]) -> Result<T> {
    if let first = items.first {
        return Result(success: first)
    }
    else {
        return Result(failure: "No item found.")
    }
}
