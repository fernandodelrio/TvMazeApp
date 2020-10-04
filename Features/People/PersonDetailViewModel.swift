//
//  PersonDetailViewModel.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/2/20.
//

import Core
import PromiseKit

class PersonDetailViewModel {
    private lazy var favoriteProvider = Dependency.resolve(FavoriteProvider.self)
    private lazy var personProvider = Dependency.resolve(PersonProvider.self)
    var selectedIndexForNavigation = 0
    // This flag helps to avoid loading the data twice
    // (when the view loads and when it appears)
    var isFirstAppear = true
    // The person came from a previous view
    var person: Person?
    // The shows and the favorite status from each one
    var data: [(show: Show, isFavorited: Bool)] = []
    var onDataChange: (() -> Void)?
    var onLoadingChange: ((_ isLoading: Bool) -> Void)?

    func load() {
        guard let person = person else {
            return
        }
        // Starts showing the loading
        onLoadingChange?(true)
        // Loads the shows of the person and the favorites
        let updatedPerson = personProvider.loadShows(person: person)
        let favorites = favoriteProvider.retrieveFavorites()
        when(fulfilled: updatedPerson, favorites)
            .done { [weak self] person, favorites in
                self?.person = person
                // Calculate the favorites
                // of the person shows
                self?.data = person.shows.map { show in
                    let isFavorited = favorites
                        .map { $0.show.id }
                        .contains(show.id)
                    return (show, isFavorited)
                }
                // Notifies the data back to the
                // view and also hides the loading
                self?.onDataChange?()
                self?.onLoadingChange?(false)
            }.cauterize()
    }

    func appear() {
        guard !isFirstAppear else {
            isFirstAppear = false
            return
        }
        guard let person = person else {
            return
        }
        // When the view appears, we don't
        // need to retrieve the shows, just the
        // updated favorites (that may have
        // change in other views)
        // Start by showing the loading
        onLoadingChange?(true)
        favoriteProvider
            .retrieveFavorites()
            .done { [weak self] favorites in
                // Calculate the favorites
                // of the person shows
                self?.data = person.shows.map { show in
                    let isFavorited = favorites
                        .map { $0.show.id }
                        .contains(show.id)
                    return (show, isFavorited)
                }
                // Notifies the data back to the
                // view and also hides the loading
                self?.onDataChange?()
                self?.onLoadingChange?(false)
            }.cauterize()
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
}
