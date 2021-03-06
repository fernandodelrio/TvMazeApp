//
//  NetworkError.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//

import Foundation

public enum NetworkError: String, Error {
    case invalidUrl = "The endpoint url is invalid"
    case dataNotFound = "The data was not found"
    case lastPageAchieved = "The last page was achieved"
    case parseFailed = "The parsing of thee network response failed"
    case rateLimitAchieved = "The rate limit was achieved"
}
