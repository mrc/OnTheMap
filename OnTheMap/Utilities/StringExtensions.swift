//
//  StringExtensions.swift
//  OnTheMap
//
//  Created by Matt Curtis on 20/05/2015.
//  Copyright (c) 2015 Matt Curtis. All rights reserved.
//

import Foundation

extension String {
    /**
        Convert (if possible) a string to Double?
    */
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}