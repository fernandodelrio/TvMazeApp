//
//  MockSecretProvider.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import Foundation
@testable import Core
@testable import PromiseKit

class MockSecretProvider: SecretProvider {
    static var mockSecrets: [String: String] = [:]
    static var mockSaveCalled = false
    func save(key: SecretKey, value: String) {
        Self.mockSaveCalled = true
        Self.mockSecrets[key.rawValue] = value
    }
    
    func retrieve(key: SecretKey) -> String {
        Self.mockSecrets[key.rawValue] ?? ""
    }
}
