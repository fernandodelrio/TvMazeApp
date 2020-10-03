//
//  ShowListViewModel.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core
import PromiseKit

class ShowListViewModel {
    private lazy var showProvider = Dependency.resolve(ShowProvider.self)
    private lazy var favoriteProvider = Dependency.resolve(FavoriteProvider.self)
    private var isSeaching = false
    private var isLoadingNewPages = false
    private var page = 0
    var selectedIndexForNavigation = 0
    var onDataChange: (() -> Void)?
    var onLoadingChange: ((_ isLoading: Bool) -> Void)?
    var onLoadingNewPageChange: ((_ isLoading: Bool) -> Void)?
    var data: [(show: Show, isFavorited: Bool)] = []
    
    func load() {
        page += 1
        onDataChange?()
        triggerLoading(isLoading: true)
        let shows = showProvider.retrieveShows(page: page)
        let favorites = favoriteProvider.retrieveFavorites()
        when(fulfilled: shows, favorites)
            .done { [weak self] shows, favorites in
                self?.reloadData(shows: shows, favorites: favorites)
            }.recover { [weak self] error in
                if (error as? NetworkError) == .lastPageAchieved {
                    self?.triggerLoading(isLoading: false)
                }
            }.cauterize()
    }

    func appear() {
        favoriteProvider
            .retrieveFavorites()
            .done { [weak self] favorites in
                let indices = self?.data.indices
                let showIds = favorites.map { $0.show.id }
                indices?.forEach {
                    self?.data[$0].isFavorited = false
                }
                indices?.forEach {
                    if showIds.contains(self?.data[$0].show.id ?? -1) {
                        self?.data[$0].isFavorited = true
                    }
                }
                self?.onDataChange?()
            }.cauterize()
    }

    func loadNewPages() {
        guard !isSeaching, !isLoadingNewPages else {
            return
        }
        isLoadingNewPages = true
        load()
    }

    func favorite(index: Int) {
        let favorite = Favorite(show: data[index].show)
        data[index].isFavorited.toggle()
        let favoriteUpdate: Promise<Void>
        if data[index].isFavorited {
            favoriteUpdate = favoriteProvider.save(favorite)
        } else {
            favoriteUpdate = favoriteProvider.delete(favorite)
        }
        favoriteUpdate.cauterize()
    }
    
    func searchTextDidChange(_ searchTerm: String) {
        if searchTerm.isEmpty {
            isSeaching = false
            page = 0
            data = []
            load()
        }
    }

    func searchTextDidEndEditing(_ searchTerm: String) {
        if !searchTerm.isEmpty {
            isSeaching = true
            page = 0
            data = []
            onDataChange?()
            triggerLoading(isLoading: true)
            let shows = showProvider.retrieveShows(searchTerm: searchTerm)
            let favorites = favoriteProvider.retrieveFavorites()
            when(fulfilled: shows, favorites)
                .done { [weak self] shows, favorites in
                    self?.reloadData(shows: shows, favorites: favorites)
                }.cauterize()
        }
    }

    private func triggerLoading(isLoading: Bool) {
        if isSeaching || page <= 1 {
            onLoadingChange?(isLoading)
            onLoadingNewPageChange?(false)
        } else {
            onLoadingNewPageChange?(isLoading)
        }
    }

    private func reloadData(shows: [Show], favorites: [Favorite]) {
        let newData = shows.map { show -> (show: Show, isFavorited: Bool) in
            let showId = show.id
            let isFavorited = favorites
                .map { $0.show.id }
                .contains(showId)
            return (show, isFavorited)
        }
        data.append(contentsOf: newData)
        onDataChange?()
        triggerLoading(isLoading: false)
        isLoadingNewPages = false
    }
}
