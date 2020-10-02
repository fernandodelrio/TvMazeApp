//
//  PeopleListViewModel.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core

class PeopleListViewModel {
    private lazy var personProvider = Dependency.resolve(PersonProvider.self)
    var onDataChange: (() -> Void)?
    var data: [Person] = []
    
    func searchTextDidChange(_ searchTerm: String) {
        if searchTerm.isEmpty {
            data = []
            onDataChange?()
        }
    }

    func searchTextDidEndEditing(_ searchTerm: String) {
        if !searchTerm.isEmpty {
            data = []
            onDataChange?()
            personProvider
                .retrievePeople(searchTerm: searchTerm)
                .done { [weak self] people in
                    self?.data = people
                    self?.onDataChange?()
                }.cauterize()
        }
    }
}
