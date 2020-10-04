//
//  EndpointProvider.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Foundation

public protocol EndpointProvider {
    func url(for endpoint: Endpoint, with args: [CVarArg]) -> URL?
}
