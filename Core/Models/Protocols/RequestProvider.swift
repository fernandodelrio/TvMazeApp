//
//  RequestProvider.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import PromiseKit

public typealias NetworkResponse = (Data, StatusCode)

public protocol RequestProvider {
    func request(endpoint: Endpoint, with args: CVarArg...) -> Promise<NetworkResponse>
    func request(url: URL) -> Promise<NetworkResponse>
}
