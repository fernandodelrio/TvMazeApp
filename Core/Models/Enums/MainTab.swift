//
//  MainTab.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

// The main tabs of the app
public enum MainTab: Int {
    case shows
    case people
    case favorites
    case settings

    public var title: String {
        switch self {
        case .shows: return "Shows".localized
        case .people: return "People".localized
        case .favorites: return "Favorites".localized
        case .settings: return "Settings".localized
        }
    }
}
