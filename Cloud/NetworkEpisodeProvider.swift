//
//  NetworkEpisodeProvider.swift
//  TvMaze
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import Core
import PromiseKit

public protocol EpisodeProvider {
    func retrieveEpisodes(showId: Int) -> Promise<[Episode]>
}

public class NetworkEpisodeProvider: EpisodeProvider {
    lazy var requestProvider = Dependency.resolve(RequestProvider.self)
    lazy var decoder = JSONDecoder()

    public init() {
    }

    public func retrieveEpisodes(showId: Int) -> Promise<[Episode]> {
        requestProvider
            .request(endpoint: .retrieveEpisodes, with: showId)
            .map { [weak self] data, statusCode -> [Episode] in
                if statusCode == .notFound {
                    throw NetworkError.dataNotFound
                }
                guard let episodes = (try? self?.decoder.decode([Episode].self, from: data)) else {
                    throw NetworkError.parseFailed
                }
                return episodes
                
            }
    }
}
