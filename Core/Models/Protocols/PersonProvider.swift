//
//  PersonProvider.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import PromiseKit

public protocol PersonProvider {
    func retrievePeople(searchTerm: String) -> Promise<[Person]>
    func loadShows(person: Person) -> Promise<Person>
}
