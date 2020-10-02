//
//  StatusCode.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import Foundation

public enum StatusCode: Int {
    case notFound = 404
    case tooManyRequests = 429
    case other
}
