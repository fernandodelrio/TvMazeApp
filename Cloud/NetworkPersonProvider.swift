//
//  NetworkPersonProvider.swift
//  Cloud
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//

import Core
import PromiseKit

public class NetworkPersonProvider: PersonProvider {
    // This queue is used to parse the response out of the main thread
    static let queue = DispatchQueue(label: "NetworkPersonProvider")
    lazy var requestProvider = Dependency.resolve(RequestProvider.self)
    lazy var showProvider = Dependency.resolve(ShowProvider.self)
    lazy var decoder = JSONDecoder()

    public init() {
    }

    // Retrieves people using a search term (make sure to url encoded the search)
    public func retrievePeople(searchTerm: String) -> Promise<[Person]> {
        // Performs the request
        requestProvider
            .request(endpoint: .retrievePeople, with: searchTerm.urlEncoded)
            .map(on: Self.queue) { [weak self] data, statusCode -> [Person] in
                if statusCode == .notFound {
                    throw NetworkError.dataNotFound
                }
                // Parses the data
                guard let people = (try? self?.decoder.decode([Person].self, from: data)) else {
                    throw NetworkError.parseFailed
                }
                return people
            }
    }

    // Fills up person with the shows it has participated
    public func loadShows(person: Person) -> Promise<Person> {
        var person = person
        // First retrieves the show IDs
        return retrieveShowIds(personId: person.id)
            .then(on: Self.queue) { showIds -> Promise<[Show]> in
                // Then retrieves each show
                let shows = showIds.map { self.showProvider.retrieveShow(id: $0) }
                return when(fulfilled: shows)
            }.map(on: Self.queue) { shows -> Person in
                // Finally fill the data and returns
                person.shows = shows
                return person
            }
    }

    // Retrieves the show ids of a person
    private func retrieveShowIds(personId: Int) -> Promise<[Int]> {
        // Performs the request
        requestProvider
            .request(endpoint: .retrieveShowsFromPerson, with: personId)
            .map(on: Self.queue) { data, statusCode -> [Int] in
                if statusCode == .notFound {
                    throw NetworkError.dataNotFound
                }
                // Parses to a simple dictionary to retrieve the ids
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
