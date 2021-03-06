//
//  AuthProvider.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import PromiseKit

public protocol AuthProvider {
    var authType: AuthType { get }
    func authenticate() -> Promise<Bool>
}
