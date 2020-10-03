//
//  ScreenType.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Foundation

public enum ScreenType {
    case iPhone_5_5S_5C
    case iPhone_6_6S_7_8
    case iPhone_6Plus_6SPlus_7Plus_8Plus
    case iPhone_X_XS_11_Pro
    case iPhone_XSMax_11ProMax
    case iPhone_XR_11
    case unknown

    public var isSmallScreen: Bool {
        [.iPhone_5_5S_5C, .iPhone_6_6S_7_8].contains(self)
    }
}
