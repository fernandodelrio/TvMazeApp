//
//  StatusCode.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Foundation

// HTTP status codes we use
public enum StatusCode: Int {
    case notFound = 404
    case tooManyRequests = 429
    case other
}
