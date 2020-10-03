//
//  FavoriteProvider.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import PromiseKit

public protocol FavoriteProvider {
    var onDataChange: ((_ favorites: [Favorite]) -> Void)? { get set }
    func save(_ favorite: Favorite) -> Promise<Void>
    func delete(_ favorite: Favorite) -> Promise<Void>
    func retrieveFavorites() -> Promise<[Favorite]>
}
