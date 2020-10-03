//
//  TouchIdAuthProvider.swift
//  Auth
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Core
import LocalAuthentication
import PromiseKit

public class TouchIdAuthProvider: AuthProvider {
    private let context = LAContext()
    private var error: NSError?
    private let reason = "Authenticate with Touch ID"
    
    public init() {
    }

    public var isEnabled: Bool {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    public func authenticate() -> Promise<Bool> {
        Promise { [weak self] seal in
            let reason = "Authenticate with Touch ID"
            self?.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                seal.fulfill(success)
            }
        }
    }
}
