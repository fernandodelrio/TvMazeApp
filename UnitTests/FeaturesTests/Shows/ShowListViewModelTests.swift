//
//  ShowListViewModelTests.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import XCTest
@testable import Features
@testable import Core

class ShowListViewModelTests: XCTestCase {
    lazy var injector = TestInjector()
    var viewModel: ShowListViewModel?

    override func setUp() {
        super.setUp()
        injector.load()
        viewModel = ShowListViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        injector.reset()
        viewModel = nil
    }

    func testLoadPage() {
        // Setup
        var isLoading: Bool?
        var isDataChangeCalled: Bool?
        viewModel?
            .onLoadingChange = { isLoading = $0 }
        viewModel?
            .onDataChange = { isDataChangeCalled = true }
        var show1 = Show()
        show1.id = 123
        var show2 = Show()
        show2.id = 456
        MockShowProvider.mockShows = [show1, show2]
        MockFavoriteProvider.mockFavorites = [Favorite(show: show1)]
        
        // Given
        XCTAssertEqual(viewModel?.data.count, 0)
        XCTAssertNil(isLoading)
        XCTAssertNil(isDataChangeCalled)

        // When
        viewModel?.load()
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(isLoading, false)
        XCTAssertEqual(isDataChangeCalled, true)
        XCTAssertEqual(viewModel?.data.first?.show.id, 123)
        XCTAssertEqual(viewModel?.data.first?.isFavorited, true)
        XCTAssertEqual(viewModel?.data.last?.show.id, 456)
        XCTAssertEqual(viewModel?.data.last?.isFavorited, false)
    }

    func testLoadOnlyFavoritesOnSecondAppear() {
        // Setup
        var isDataChangeCalled: Bool?
        viewModel?
            .onDataChange = { isDataChangeCalled = true }
        var show1 = Show()
        show1.id = 123
        var show2 = Show()
        show2.id = 456
        MockShowProvider.mockShows = [show1, show2]
        MockFavoriteProvider.mockFavorites = [Favorite(show: show1)]
        
        // Given
        viewModel?.load()
        wait(timeout: 0.5)
        viewModel?.appear()
        wait(timeout: 0.5)
        XCTAssertEqual(viewModel?.data.first?.show.id, 123)
        XCTAssertEqual(viewModel?.data.first?.isFavorited, true)
        XCTAssertEqual(viewModel?.data.last?.show.id, 456)
        XCTAssertEqual(viewModel?.data.last?.isFavorited, false)
        isDataChangeCalled = nil

        // When
        MockFavoriteProvider.mockFavorites = [Favorite(show: show2)]
        viewModel?.appear()
        wait(timeout: 0.5)

        // Then
        XCTAssertEqual(viewModel?.data.first?.show.id, 123)
        XCTAssertEqual(viewModel?.data.first?.isFavorited, false)
        XCTAssertEqual(viewModel?.data.last?.show.id, 456)
        XCTAssertEqual(viewModel?.data.last?.isFavorited, true)
        XCTAssertEqual(isDataChangeCalled, true)
    }

    func testFavoriteChange() {
        // Setup
        var show1 = Show()
        show1.id = 123
        var show2 = Show()
        show2.id = 456
        MockShowProvider.mockShows = [show1, show2]
        MockFavoriteProvider.mockFavorites = []

        // Given
        viewModel?.load()
        wait(timeout: 0.5)
        XCTAssertEqual(viewModel?.data.first?.show.id, 123)
        XCTAssertEqual(viewModel?.data.first?.isFavorited, false)
        XCTAssertEqual(viewModel?.data.last?.show.id, 456)
        XCTAssertEqual(viewModel?.data.last?.isFavorited, false)

        // When
        viewModel?.favorite(index: 1)
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(viewModel?.data.first?.show.id, 123)
        XCTAssertEqual(viewModel?.data.first?.isFavorited, false)
        XCTAssertEqual(viewModel?.data.last?.show.id, 456)
        XCTAssertEqual(viewModel?.data.last?.isFavorited, true)
    }
}
