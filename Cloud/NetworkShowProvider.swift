//
//  NetworkShowProvider.swift
//  Cloud
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import Core
import PromiseKit

public class NetworkShowProvider: ShowProvider {
    lazy var episodeProvider = Dependency.resolve(EpisodeProvider.self)
    lazy var requestProvider = Dependency.resolve(RequestProvider.self)
    lazy var decoder = JSONDecoder()
    static let queue = DispatchQueue(label: "NetworkShowProvider")

    public init() {
    }

    public func retrieveShows(page: Int) -> Promise<[Show]> {
        requestProvider
            .request(endpoint: .retrieveShows, with: page)
            .map(on: Self.queue) { [weak self] data, statusCode -> [Show] in
                if statusCode == .notFound {
                    throw NetworkError.lastPageAchieved
                }
                guard let shows = (try? self?.decoder.decode([Show].self, from: data)) else {
                    throw NetworkError.parseFailed
                }
                return shows
            }
    }

    public func retrieveShows(searchTerm: String) -> Promise<[Show]> {
        requestProvider
            .request(endpoint: .retrieveShowsFromSearch, with: searchTerm.urlEncoded)
            .map(on: Self.queue) { [weak self] data, statusCode -> [Show] in
                guard statusCode != .notFound else {
                    throw NetworkError.dataNotFound
                }
                let jsonObject = (try? JSONSerialization.jsonObject(
                    with: data,
                    options: []
                ) as? [[String: Any]]) ?? []
                let adjustedJsonArray = jsonObject.compactMap { $0["show"] }
                let adjustedJsonData = (try? JSONSerialization.data(
                    withJSONObject: adjustedJsonArray,
                    options: []
                )) ?? Data()
                guard let shows = (try? self?.decoder.decode([Show].self, from: adjustedJsonData)) else {
                    throw NetworkError.parseFailed
                }
                return shows
            }
    }

    public func retrieveShow(id: Int) -> Promise<Show> {
        requestProvider
            .request(endpoint: .retrieveShow, with: id)
            .map(on: Self.queue) { [weak self] data, statusCode-> Show in
                guard statusCode != .notFound else {
                    throw NetworkError.dataNotFound
                }
                guard let show = (try? self?.decoder.decode(Show.self, from: data)) else {
                    throw NetworkError.parseFailed
                }
                return show
            }
    }

    public func retrieveEpisodes(show: Show) -> Promise<Show> {
        var show = show
        let episodes = episodeProvider.retrieveEpisodes(showId: show.id)
        return episodes
            .map(on: Self.queue) { episodes -> Show in
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
