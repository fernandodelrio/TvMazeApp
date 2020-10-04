//
//  MockPersonProvider.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import Foundation
@testable import Core
@testable import PromiseKit

class MockPersonProvider: PersonProvider {
    static var mockPeople: [Person] = []
    static var mockPerson: Person?
    static var mockShows: [Show] = []

    func retrievePeople(searchTerm: String) -> Promise<[Person]> {
        .value(Self.mockPeople)
    }
    
    func loadShows(person: Person) -> Promise<Person> {
        if var mockPerson = Self.mockPerson {
            mockPerson.shows = Self.mockShows
            return .value(mockPerson)
        } else {
            return .init(error: TestError.mockNotSet)
        }
    }
}
