//
//  FavoriteListViewModel.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core
import PromiseKit

class FavoriteListViewModel {
    private lazy var showProvider = Dependency.resolve(ShowProvider.self)
    private lazy var favoriteProvider = Dependency.resolve(FavoriteProvider.self)
    var onDataChange: (() -> Void)?
    var onDataDelete: ((_ indexPath: IndexPath) -> Void)?
    var onLoadingChange: ((_ isLoading: Bool) -> Void)?
    var selectedIndexForNavigation = 0
    var data: [(show: Show, isFavorited: Bool)] = []

    func appear() {
        data = []
        onDataChange?()
        onLoadingChange?(true)
        favoriteProvider
            .retrieveFavorites()
            .done { [weak self] favorites in
                let shows = favorites.map { $0.show }
                self?.data = shows
                    .map { ($0, true) }
                    .sorted { $0.show.name < $1.show.name }
                self?.onDataChange?()
                self?.onLoadingChange?(false)
            }.cauterize()
    }

    func unfavorite(index: Int) {
        let favorite = Favorite(show: data[index].show)
        data.remove(at: index)
        favoriteProvider.delete(favorite).cauterize()
        onDataDelete?(IndexPath(row: index, section: 0))
    }
}
