//
//  AuthType.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Foundation

public enum AuthType {
    case touchID
    case faceID
    case unsupported

    public var localized: String {
        switch self {
        case .touchID: return "Touch ID"
        case .faceID: return "Face ID"
        case .unsupported: return "Unsupported"
        }
    }
}
