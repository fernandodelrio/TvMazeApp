//
//  UIDevice+ScreenType.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import UIKit

public extension UIDevice {
    static var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 1136: return .iPhone_5_5S_5C
        case 1334: return .iPhone_6_6S_7_8
        case 1792: return .iPhone_XR_11
        case 1920, 2208: return .iPhone_6Plus_6SPlus_7Plus_8Plus
        case 2436: return .iPhone_X_XS_11_Pro
        case 2688: return .iPhone_XSMax_11ProMax
        default: return .unknown
        }
    }
}
