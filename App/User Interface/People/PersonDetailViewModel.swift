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
    var isFirstAppear = true
    var person: Person?
    var data: [(show: Show, isFavorited: Bool)] = []
    var onDataChange: (() -> Void)?
    var onLoadingChange: ((_ isLoading: Bool) -> Void)?

    func load() {
        guard let person = person else {
            return
        }
        onLoadingChange?(true)
        let updatedPerson = personProvider.loadShows(person: person)
        let favorites = favoriteProvider.retrieveFavorites()
        when(fulfilled: updatedPerson, favorites)
            .done { [weak self] person, favorites in
                self?.person = person
                self?.data = person.shows.map { show in
                    let isFavorited = favorites
                        .map { $0.show.id }
                        .contains(show.id)
                    return (show, isFavorited)
                }
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
        onLoadingChange?(true)
        favoriteProvider
            .retrieveFavorites()
            .done { [weak self] favorites in
                self?.data = person.shows.map { show in
                    let isFavorited = favorites
                        .map { $0.show.id }
                        .contains(show.id)
                    return (show, isFavorited)
                }
                self?.onDataChange?()
                self?.onLoadingChange?(false)
            }.cauterize()
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
}
