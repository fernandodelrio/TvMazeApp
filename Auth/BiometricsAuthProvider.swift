//
//  BiometricsAuthProvider.swift
//  Auth
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Core
import LocalAuthentication
import PromiseKit

// Provides authentication using touch ID or face ID
public class BiometricsAuthProvider: AuthProvider {
    private let context = LAContext()
    private var error: NSError?
    private let reason = "Authenticate with the app".localized

    // Checks if the device supports touch ID or face ID
    public var authType: AuthType {
        let isEnabled = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if #available(iOS 11, *) {
            if isEnabled, context.biometryType == .touchID {
                return .touchID
            } else if isEnabled, context.biometryType == .faceID {
                return .faceID
            }
        } else {
            // There was no face ID until iOS 11
            if isEnabled {
                return .touchID
            }
        }
        return .unsupported
    }

    public init() {
    }

    // Asks to authenticate, then returns a promise
    // indicating if it succeeded
    public func authenticate() -> Promise<Bool> {
        Promise { [weak self] seal in
            self?.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                seal.fulfill(success)
            }
        }
    }
}
