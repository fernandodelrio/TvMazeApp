//
//  UIDevice+ScreenType.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import UIKit

public extension UIDevice {
    // Maps devices screen sizes to the proper device family
    static var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 1136: return .iPhone5to5C
        case 1334: return .iPhone6to8
        case 1792: return .iPhoneXRto11
        case 1920, 2208: return .iPhone6to8Plus
        case 2436: return .iPhoneXto11Pro
        case 2688: return .iPhoneXSMaxTo11ProMax
        default: return .unknown
        }
    }
}
