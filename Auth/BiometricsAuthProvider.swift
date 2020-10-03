//
//  BiometricsAuthProvider.swift
//  Auth
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Core
import LocalAuthentication
import PromiseKit

public class BiometricsAuthProvider: AuthProvider {
    private let context = LAContext()
    private var error: NSError?
    private let reason = "Authenticate with Touch ID"

    public init() {
    }

    public var authType: AuthType {
        let isEnabled = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if #available(iOS 11, *) {
            if isEnabled, context.biometryType == .touchID {
                return .touchID
            } else if isEnabled, context.biometryType == .faceID {
                return .faceID
            }
        } else {
            if isEnabled {
                return .touchID
            }
        }
        return .unsupported
    }

    public func authenticate() -> Promise<Bool> {
        Promise { [weak self] seal in
            let reason = "Authenticate with the app"
            self?.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                seal.fulfill(success)
            }
        }
    }
}
