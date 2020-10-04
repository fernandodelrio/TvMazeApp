//
//  PersonListViewModel.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core

class PersonListViewModel {
    private lazy var personProvider = Dependency.resolve(PersonProvider.self)
    var onDataChange: (() -> Void)?
    var onLoadingChange: ((_ isLoading: Bool) -> Void)?
    var onSearchEmpty: ((_ isEmpty: Bool) -> Void)?
    var selectedIndexForNavigation = 0
    var data: [Person] = []

    func load() {
        onDataChange?()
        onSearchEmpty?(true)
    }

    // When there's an empty search, clear the view
    func searchTextDidChange(_ searchTerm: String) {
        if searchTerm.isEmpty {
            data = []
            onDataChange?()
        }
        onSearchEmpty?(searchTerm.isEmpty)
    }

    func searchTextDidEndEditing(_ searchTerm: String) {
        if !searchTerm.isEmpty {
            // When there's a non empty search
            // clear the view
            data = []
            onDataChange?()
            // Show a loading
            onLoadingChange?(true)
            // Retrieve the people data from
            // the search term
            personProvider
                .retrievePeople(searchTerm: searchTerm)
                .done { [weak self] people in
                    self?.data = people
                    // Notifies the data back to the
                    // view and also hides the loading
                    self?.onDataChange?()
                    self?.onLoadingChange?(false)
                }.cauterize()
        }
    }
}
