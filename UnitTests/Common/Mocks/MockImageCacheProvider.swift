//
//  MockImageCacheProvider.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import Foundation
@testable import Core
@testable import PromiseKit

class MockImageCacheProvider: ImageCacheProvider {
    static var mockSaveCalled = false
    static var mockImage: UIImage?

    func save(_ image: UIImage, for url: URL) {
        Self.mockSaveCalled = true
    }
    
    func retrieve(_ url: URL) -> UIImage? {
        Self.mockImage
    }
}
