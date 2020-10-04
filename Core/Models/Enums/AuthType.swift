//
//  AuthType.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Foundation

// The authentication types. Unsupported means, we
// will use the custom PIN
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
