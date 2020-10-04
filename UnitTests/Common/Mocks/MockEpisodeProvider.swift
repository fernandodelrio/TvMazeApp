//
//  MockEpisodeProvider.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import Foundation
@testable import Core
@testable import PromiseKit

class MockEpisodeProvider: EpisodeProvider {
    static var mockEpisodes: [Episode] = []

    func retrieveEpisodes(showId: Int) -> Promise<[Episode]> {
        .value(Self.mockEpisodes)
    }
}
