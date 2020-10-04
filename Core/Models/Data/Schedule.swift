//
//  Schedule.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//

import Foundation

public struct Schedule: Decodable {
    public var time: String
    public var days: [String]
}
