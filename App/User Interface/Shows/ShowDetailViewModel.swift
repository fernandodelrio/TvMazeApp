//
//  ShowDetailViewModel.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/2/20.
//

import Core
import PromiseKit

class ShowDetailViewModel {
    private lazy var episodeProvider = Dependency.resolve(EpisodeProvider.self)
    private lazy var showProvider = Dependency.resolve(ShowProvider.self)
    private lazy var favoriteProvider = Dependency.resolve(FavoriteProvider.self)
    private var isFirstAppear = true
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
        onLoadingChange?(true)
        showProvider
            .retrieveEpisodes(show: show)
            .done { [weak self] show in
                self?.show = show
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
        favoriteProvider
            .retrieveFavorites()
            .done { [weak self] favorites in
                let isFavorited = favorites
                    .map { $0.show.id }
                    .contains(show.id)
                self?.isFavorited = isFavorited
                self?.onFavoriteChange?(isFavorited)
            }.cauterize()
    }

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
