//
//  ShowListViewModel.swift
//  Features
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core
import PromiseKit

class ShowListViewModel {
    private lazy var showProvider = Dependency.resolve(ShowProvider.self)
    private lazy var favoriteProvider = Dependency.resolve(FavoriteProvider.self)
    // When searching, we may reach the bottom of the view
    // but in this case we don't want to retrieve new pages
    private var isSeaching = false
    // This flag helps to avoid loading new
    // pages multiple times, as the view
    // may call more than once
    private var isLoadingNewPages = false
    // Keeps track of the current loaded page
    // increment always it wants to retrieve a new page
    private var page = 0
    // This flag helps to avoid loading the data twice
    // (when the view loads and when it appears)
    private var isFirstAppear = true
    var selectedIndexForNavigation = 0
    var onDataChange: (() -> Void)?
    var onLoadingChange: ((_ isLoading: Bool) -> Void)?
    var onLoadingNewPageChange: ((_ isLoading: Bool) -> Void)?
    // The shows and the favorite status from each one
    var data: [(show: Show, isFavorited: Bool)] = []

    func load() {
        // Increments the page and then loads new data
        // as it starts with zero, the first call will
        // be page 1
        page += 1
        onDataChange?()
        // Shows a loading
        triggerLoading(isLoading: true)
        // Retrieve the shows for the current page
        // and also the favorites
        let shows = showProvider.retrieveShows(page: page)
        let favorites = favoriteProvider.retrieveFavorites()
        when(fulfilled: shows, favorites)
            .done { [weak self] shows, favorites in
                // If success, reloads the view with the
                // new data
                self?.reloadData(shows: shows, favorites: favorites)
            }.recover { [weak self] error in
                // If there's some error, we need to check.
                // When the error is lastPageAchieved, this means
                // there's no more page to retrieve
                // Then we stop the loading and finish. As we never
                // call the reload, the isLoadingNewPages will
                // never be set to false and new pages won't be
                // retrieved any more
                if (error as? NetworkError) == .lastPageAchieved {
                    self?.triggerLoading(isLoading: false)
                }
            }.cauterize()
    }

    func appear() {
        guard !isFirstAppear else {
            isFirstAppear = false
            return
        }
        // When the view appears, we don't
        // need to retrieve the shows, just the
        // updated favorites (that may have
        // change in other views)
        favoriteProvider
            .retrieveFavorites()
            .done { [weak self] favorites in
                let indices = self?.data.indices
                let showIds = favorites.map { $0.show.id }
                // Calculate the favorites
                // of the shows
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
        // Don't load new pages if it's a search
        // or if it's already loading new pages
        guard !isSeaching, !isLoadingNewPages else {
            return
        }
        isLoadingNewPages = true
        load()
    }

    // Adds or removes the favorite from the database
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

    // When there's an empty search, clear the view
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
            // When there's a non empty search
            // clear the view
            isSeaching = true
            page = 0
            data = []
            onDataChange?()
            // Show a loading
            triggerLoading(isLoading: true)
            // Retrieve the shows and the
            // updated favorites
            let shows = showProvider.retrieveShows(searchTerm: searchTerm)
            let favorites = favoriteProvider.retrieveFavorites()
            when(fulfilled: shows, favorites)
                .done { [weak self] shows, favorites in
                    // Reloads the view
                    self?.reloadData(shows: shows, favorites: favorites)
                }.cauterize()
        }
    }

    private func triggerLoading(isLoading: Bool) {
        if isSeaching || page <= 1 {
            // If searching or it's the first page
            // don't trigger the bottom loading
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
