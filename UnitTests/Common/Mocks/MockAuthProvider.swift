//
//  MockAuthProvider.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import Foundation
@testable import Core
@testable import PromiseKit

class MockAuthProvider: AuthProvider {
    static var mockAuthType = AuthType.unsupported
    static var mockAuthenticateResult = false

    var authType: AuthType {
        Self.mockAuthType
    }
    
    func authenticate() -> Promise<Bool> {
        .value(Self.mockAuthenticateResult)
    }
}
