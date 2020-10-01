//
//  NetworkPersonProvider.swift
//  TvMaze
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import Core
import PromiseKit

public class NetworkPersonProvider: PersonProvider {
    lazy var requestProvider = Dependency.resolve(RequestProvider.self)
    lazy var showProvider = Dependency.resolve(ShowProvider.self)
    lazy var decoder = JSONDecoder()

    public init() {
    }

    public func retrievePeople(searchTerm: String) -> Promise<[Person]> {
        requestProvider
            .request(endpoint: .retrievePeople, with: searchTerm.urlEncoded)
            .map { [weak self] data, statusCode -> [Person] in
                if statusCode == .notFound {
                    throw NetworkError.dataNotFound
                }
                guard let people = (try? self?.decoder.decode([Person].self, from: data)) else {
                    throw NetworkError.parseFailed
                }
                return people
            }
    }

    public func loadShows(person: Person) -> Promise<Person> {
        var person = person
        return retrieveShowIds(personId: person.id)
            .then { showIds -> Promise<[Show]> in
                let shows = showIds.map { self.showProvider.retrieveShow(id: $0) }
                return when(fulfilled: shows)
            }.map { shows -> Person in
                person.shows = shows
                return person
            }
    }

    private func retrieveShowIds(personId: Int) -> Promise<[Int]> {
        requestProvider
            .request(endpoint: .retrieveShowsFromPerson, with: personId)
            .map { data, statusCode -> [Int] in
                if statusCode == .notFound {
                    throw NetworkError.dataNotFound
                }
                let showsFromPerson = (try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                ) as? [[String: Any]]) ?? []
                let urlStrings: [String] = showsFromPerson
                    .compactMap {
                        let links = $0["_links"] as? [String: Any]
                        let show = links?["show"] as? [String: Any]
                        return show?["href"] as? String
                    }
                let ids = urlStrings.compactMap {
                    $0.split(separator: "/").last.map { Int($0) ?? 0 }
                }
                return ids
            }
    }
}
