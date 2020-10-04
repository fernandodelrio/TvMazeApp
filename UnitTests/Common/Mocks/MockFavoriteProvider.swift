//
//  MockFavoriteProvider.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import Foundation
@testable import Core
@testable import PromiseKit

class MockFavoriteProvider: FavoriteProvider {
    static var mockFavorites: [Favorite] = []
    static var mockSaveCalled = false
    static var mockDeleteCalled = false
    var onDataChange: (([Favorite]) -> Void)?

    func save(_ favorite: Favorite) -> Promise<Void> {
        Self.mockSaveCalled = true
        return .value(())
    }
    
    func delete(_ favorite: Favorite) -> Promise<Void> {
        Self.mockDeleteCalled = true
        return .value(())
    }
    
    func retrieveFavorites() -> Promise<[Favorite]> {
        .value(Self.mockFavorites)
    }
}
