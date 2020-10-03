//
//  SettingsProvider.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import PromiseKit

public protocol SettingsProvider {
    func save(_ settings: Settings) -> Promise<Void>
    func retrieveSettings() -> Promise<Settings>
}
