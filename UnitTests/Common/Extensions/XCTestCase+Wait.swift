//
//  XCTestCase+Wait.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import XCTest

extension XCTestCase {
    func wait(timeout: TimeInterval) {
        let exp = expectation(description: UUID().uuidString)
        _ = XCTWaiter.wait(for: [exp], timeout: timeout)
    }
}
