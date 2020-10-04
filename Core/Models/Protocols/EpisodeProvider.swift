//
//  EpisodeProvider.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import PromiseKit

public protocol EpisodeProvider {
    func retrieveEpisodes(showId: Int) -> Promise<[Episode]>
}
