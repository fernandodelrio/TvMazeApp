//
//  ShowDetailsViewModelTests.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import XCTest
@testable import Features
@testable import Core

class ShowDetailsViewModelTests: XCTestCase {
    lazy var injector = TestInjector()
    var viewModel: ShowDetailViewModel?

    override func setUp() {
        super.setUp()
        injector.load()
        viewModel = ShowDetailViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        injector.reset()
        viewModel = nil
    }

    func testLoadEpisodes() {
        // Setup
        var isLoading: Bool?
        var isDataChangeCalled: Bool?
        viewModel?
            .onLoadingChange = { isLoading = $0 }
        viewModel?
            .onDataChange = { isDataChangeCalled = true }
        var show = Show()
        show.id = 123
        var episode = Episode()
        episode.id = 456
        MockShowProvider.mockShow = show
        MockShowProvider.mockEpisodes = [episode]
        
        // Given
        viewModel?.show = show
        XCTAssertEqual(viewModel?.show?.episodesBySeason.count, 0)
        XCTAssertNil(isLoading)
        XCTAssertNil(isDataChangeCalled)

        // When
        viewModel?.load()
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(viewModel?.show?.episodesBySeason.count, 1)
        XCTAssertEqual(isLoading, false)
        XCTAssertEqual(isDataChangeCalled, true)
    }

    func testLoadFavoritesOnSecondAppear() {
        // Setup
        var isFavorited: Bool?
        viewModel?
            .onFavoriteChange = { isFavorited = $0 }
        var show = Show()
        show.id = 123
        var episode = Episode()
        episode.id = 456
        MockShowProvider.mockShow = show
        MockShowProvider.mockEpisodes = [episode]
        let favorite = Favorite(show: show)
        MockFavoriteProvider.mockFavorites = [favorite]

        // Given
        viewModel?.show = show
        viewModel?.appear()
        XCTAssertEqual(viewModel?.isFavorited, false)
        XCTAssertNil(isFavorited)

        // When
        viewModel?.appear()
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(viewModel?.isFavorited, true)
        XCTAssertEqual(isFavorited, true)
    }

    func testFavoriteChange() {
        // Setup
        var isDataChangeCalled: Bool?
        viewModel?
            .onDataChange = { isDataChangeCalled = true }
        var show = Show()
        show.id = 123
        MockShowProvider.mockShow = show

        // Given
        viewModel?.show = show
        XCTAssertEqual(viewModel?.isFavorited, false)
        XCTAssertNil(isDataChangeCalled)

        // When
        viewModel?.favorite()
        
        // Then
        XCTAssertEqual(viewModel?.isFavorited, true)
        XCTAssertEqual(isDataChangeCalled, true)
    }
}
