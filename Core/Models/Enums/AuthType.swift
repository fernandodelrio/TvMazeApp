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

    public var title: String {
        switch self {
        case .touchID: return "Touch ID".localized
        case .faceID: return "Face ID".localized
        case .unsupported: return "Unsupported".localized
        }
    }
}
