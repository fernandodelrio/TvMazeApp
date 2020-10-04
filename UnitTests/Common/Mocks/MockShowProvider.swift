//
//  MockShowProvider.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import Foundation
@testable import Core
@testable import PromiseKit

class MockShowProvider: ShowProvider {
    static var mockShows: [Show] = []
    static var mockShow: Show?
    static var mockEpisodes: [Episode] = []

    func retrieveShows(page: Int) -> Promise<[Show]> {
        .value(Self.mockShows)
    }
    
    func retrieveShows(searchTerm: String) -> Promise<[Show]> {
        .value(Self.mockShows)
    }
    
    func retrieveShow(id: Int) -> Promise<Show> {
        if let mockShow = Self.mockShow {
            return .value(mockShow)
        } else {
            return .init(error: TestError.mockNotSet)
        }
    }
    
    func retrieveEpisodes(show: Show) -> Promise<Show> {
        if var mockShow = Self.mockShow {
            mockShow.episodesBySeason = [1: Self.mockEpisodes]
            return .value(mockShow)
        } else {
            return .init(error: TestError.mockNotSet)
        }
    }
}
