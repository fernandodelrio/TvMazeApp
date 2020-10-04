//
//  MockEndpointProvider.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import Foundation
@testable import Core
@testable import PromiseKit

class MockEndpointProvider: EndpointProvider {
    static var mockUrl: URL?

    func url(for endpoint: Endpoint, with args: [CVarArg]) -> URL? {
        Self.mockUrl
    }
}
