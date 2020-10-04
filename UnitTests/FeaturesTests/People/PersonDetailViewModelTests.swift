//
//  PersonDetailViewModelTests.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import XCTest
@testable import Features
@testable import Core

class PersonDetailViewModelTests: XCTestCase {
    lazy var injector = TestInjector()
    var viewModel: PersonDetailViewModel?

    override func setUp() {
        super.setUp()
        injector.load()
        viewModel = PersonDetailViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        injector.reset()
        viewModel = nil
    }

    func testLoadShows() {
        // Setup
        var isDataChangeCalled: Bool?
        var isLoading: Bool?
        viewModel?
            .onDataChange = { isDataChangeCalled = true }
        viewModel?
            .onLoadingChange = { isLoading = $0 }
        var person = Person()
        person.id = 123
        var show1 = Show()
        show1.id = 456
        var show2 = Show()
        show2.id = 789
        MockPersonProvider.mockPerson = person
        MockPersonProvider.mockShows = [show1, show2]
        MockFavoriteProvider.mockFavorites = [Favorite(show: show2)]

        // Given
        viewModel?.person = person
        XCTAssertEqual(viewModel?.data.count, 0)
        XCTAssertNil(isDataChangeCalled)
        XCTAssertNil(isLoading)

        // When
        viewModel?.load()
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(viewModel?.data.first?.show.id, 456)
        XCTAssertEqual(viewModel?.data.first?.isFavorited, false)
        XCTAssertEqual(viewModel?.data.last?.show.id, 789)
        XCTAssertEqual(viewModel?.data.last?.isFavorited, true)
        XCTAssertEqual(isDataChangeCalled, true)
        XCTAssertEqual(isLoading, false)
    }

    func testLoadFavoritesOnSecondAppear() {
        // Setup
        var isDataChangeCalled: Bool?
        var isLoading: Bool?
        viewModel?
            .onLoadingChange = { isLoading = $0 }
        viewModel?
            .onDataChange = { isDataChangeCalled = true }
        var person = Person()
        person.id = 123
        var show = Show()
        show.id = 456
        person.shows = [show]
        MockPersonProvider.mockPerson = person
        MockPersonProvider.mockShows = [show]
        MockFavoriteProvider.mockFavorites = []

        // Given
        viewModel?.person = person
        viewModel?.load()
        wait(timeout: 0.5)
        viewModel?.appear()
        wait(timeout: 0.5)
        XCTAssertEqual(viewModel?.data.first?.show.id, 456)
        XCTAssertEqual(viewModel?.data.first?.isFavorited, false)
        isDataChangeCalled = nil
        isLoading = nil

        // When
        MockFavoriteProvider.mockFavorites = [Favorite(show: show)]
        viewModel?.appear()
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(viewModel?.data.first?.show.id, 456)
        XCTAssertEqual(viewModel?.data.first?.isFavorited, true)
        XCTAssertEqual(isDataChangeCalled, true)
        XCTAssertEqual(isLoading, false)
    }
}
