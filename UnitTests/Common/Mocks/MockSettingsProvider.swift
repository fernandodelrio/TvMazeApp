//
//  MockSettingsProvider.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import Foundation
@testable import Core
@testable import PromiseKit

class MockSettingsProvider: SettingsProvider {
    static var mockSettings: Settings?
    static var mockSaveCalled = false

    func save(_ settings: Settings) -> Promise<Void> {
        Self.mockSaveCalled = true
        return .value(())
    }
    
    func retrieveSettings() -> Promise<Settings> {
        if let mockSettings = Self.mockSettings {
            return .value(mockSettings)
        } else {
            return .init(error: TestError.mockNotSet)
        }
    }
}
