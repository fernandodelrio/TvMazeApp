//
//  ShowDetailViewModel.swift
//  Features
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/2/20.
//

import Core
import PromiseKit

class ShowDetailViewModel {
    private lazy var showProvider = Dependency.resolve(ShowProvider.self)
    private lazy var favoriteProvider = Dependency.resolve(FavoriteProvider.self)
    // This flag helps to avoid loading the data twice
    // (when the view loads and when it appears)
    private var isFirstAppear = true
    // The show came from a previous view
    var show: Show?
    var isFavorited = false
    var selectedIndexPathForNavigation = IndexPath()
    var onDataChange: (() -> Void)?
    var onLoadingChange: ((_ isLoading: Bool) -> Void)?
    var onFavoriteChange: ((_ isFavorited: Bool) -> Void)?

    func load() {
        guard let show = show else {
            return
        }
        // Starts showing the loading
        onLoadingChange?(true)
        // Loads the episodes from the show
        showProvider
            .retrieveEpisodes(show: show)
            .done { [weak self] show in
                self?.show = show
                // Notify the data back to the view
                // also hides the loading
                self?.onDataChange?()
                self?.onLoadingChange?(false)
            }.cauterize()
    }

    func appear() {
        guard !isFirstAppear else {
            isFirstAppear = false
            return
        }
        guard let show = show else {
            return
        }
        // When the view appears, we don't
        // need to retrieve the episodes, just the
        // updated favorites (that may have
        // change in other views)
        favoriteProvider
            .retrieveFavorites()
            .done { [weak self] favorites in
                let isFavorited = favorites
                    .map { $0.show.id }
                    .contains(show.id)
                self?.isFavorited = isFavorited
                // Notifies the data back to the view
                self?.onFavoriteChange?(isFavorited)
            }.cauterize()
    }

    // Adds or removes the favorite from the database
    func favorite() {
        guard let show = show else {
            return
        }
        let favorite = Favorite(show: show)
        isFavorited.toggle()
        let favoriteUpdate: Promise<Void>
        if isFavorited {
            favoriteUpdate = favoriteProvider.save(favorite)
        } else {
            favoriteUpdate = favoriteProvider.delete(favorite)
        }
        favoriteUpdate.cauterize()
        onDataChange?()
    }
}
