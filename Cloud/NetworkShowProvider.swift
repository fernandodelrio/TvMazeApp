//
//  NetworkShowProvider.swift
//  Cloud
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//

import Core
import PromiseKit

public class NetworkShowProvider: ShowProvider {
    lazy var episodeProvider = Dependency.resolve(EpisodeProvider.self)
    lazy var requestProvider = Dependency.resolve(RequestProvider.self)
    lazy var decoder = JSONDecoder()
    // This queue is used to parse the response out of the main thread
    static let queue = DispatchQueue(label: "NetworkShowProvider")

    public init() {
    }

    // Retrieves the shows for a specific page
    public func retrieveShows(page: Int) -> Promise<[Show]> {
        // Performs the request
        requestProvider
            .request(endpoint: .retrieveShows, with: page)
            .map(on: Self.queue) { [weak self] data, statusCode -> [Show] in
                // If the status code is not found
                // it means we reached the last page
                if statusCode == .notFound {
                    throw NetworkError.lastPageAchieved
                }
                // Parses the data
                guard let shows = (try? self?.decoder.decode([Show].self, from: data)) else {
                    throw NetworkError.parseFailed
                }
                return shows
            }
    }

    // Retrieves the shows for a specific search trm
    public func retrieveShows(searchTerm: String) -> Promise<[Show]> {
        // Performs the request (make sure to url encoded the search)
        requestProvider
            .request(endpoint: .retrieveShowsFromSearch, with: searchTerm.urlEncoded)
            .map(on: Self.queue) { [weak self] data, statusCode -> [Show] in
                guard statusCode != .notFound else {
                    throw NetworkError.dataNotFound
                }
                // The show is wrapped, let's convert to a dictionary to
                // unwrap it
                let jsonObject = (try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                ) as? [[String: Any]]) ?? []
                let adjustedJsonArray = jsonObject.compactMap { $0["show"] }
                let adjustedJsonData = (try? JSONSerialization.data(
                    withJSONObject: adjustedJsonArray,
                    options: []
                )) ?? Data()
                // Then parses the data
                guard let shows = (try? self?.decoder.decode([Show].self, from: adjustedJsonData)) else {
                    throw NetworkError.parseFailed
                }
                return shows
            }
    }

    // Retrieve a show for a particular id
    public func retrieveShow(id: Int) -> Promise<Show> {
        // Performs the request
        requestProvider
            .request(endpoint: .retrieveShow, with: id)
            .map(on: Self.queue) { [weak self] data, statusCode -> Show in
                guard statusCode != .notFound else {
                    throw NetworkError.dataNotFound
                }
                // Parses the data
                guard let show = (try? self?.decoder.decode(Show.self, from: data)) else {
                    throw NetworkError.parseFailed
                }
                return show
            }
    }

    // Retrieves the episodes of a particular show
    public func retrieveEpisodes(show: Show) -> Promise<Show> {
        var show = show
        // Ask episode provider passing the show id
        let episodes = episodeProvider.retrieveEpisodes(showId: show.id)
        return episodes
            .map(on: Self.queue) { episodes -> Show in
                // Split the episodes into seasons
                show.episodesBySeason = [:]
                let seasons = Set(episodes.map { $0.season })
                seasons.forEach {
                    show.episodesBySeason[$0] = []
                }
                episodes.forEach {
                    show.episodesBySeason[$0.season]?.append($0)
                }
                return show
            }
    }
}
