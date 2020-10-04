//
//  FavoriteListViewModelTests.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import XCTest
@testable import Features
@testable import Core

class FavoriteListViewModelTests: XCTestCase {
    lazy var injector = TestInjector()
    var viewModel: FavoriteListViewModel?

    override func setUp() {
        super.setUp()
        injector.load()
        viewModel = FavoriteListViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        injector.reset()
        viewModel = nil
    }

    func testLoadFavorites() {
        // Setup
        var isLoading: Bool?
        var isDataChangeCalled: Bool?
        viewModel?
            .onLoadingChange = { isLoading = $0 }
        viewModel?
            .onDataChange = { isDataChangeCalled = true }
        var show1 = Show()
        show1.name = "QWERT"
        var show2 = Show()
        show2.name = "ASDFG"
        var show3 = Show()
        show3.name = "ZXCVB"
        MockFavoriteProvider.mockFavorites = [show1, show2, show3]
            .map { Favorite(show: $0) }
        
        // Given
        XCTAssertEqual(viewModel?.data.count, 0)
        XCTAssertNil(isLoading)
        XCTAssertNil(isDataChangeCalled)
        
        // When
        viewModel?.appear()
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(viewModel?.data.count, 3)
        XCTAssertEqual(viewModel?.data[0].show.name, "ASDFG")
        XCTAssertEqual(viewModel?.data[1].show.name, "QWERT")
        XCTAssertEqual(viewModel?.data[2].show.name, "ZXCVB")
        XCTAssertEqual(isLoading, false)
        XCTAssertEqual(isDataChangeCalled, true)
    }

    func testUnfavorite() {
        // Setup
        var deletedIndexPath: IndexPath?
        viewModel?
            .onDataDelete = { deletedIndexPath = $0 }
        var show1 = Show()
        show1.name = "QWERT"
        var show2 = Show()
        show2.name = "ASDFG"
        var show3 = Show()
        show3.name = "ZXCVB"
        MockFavoriteProvider.mockFavorites = [show1, show2, show3]
            .map { Favorite(show: $0) }
        
        // Given
        viewModel?.appear()
        wait(timeout: 0.5)
        XCTAssertNil(deletedIndexPath)
        XCTAssertEqual(viewModel?.data.count, 3)
        
        // When
        viewModel?.unfavorite(index: 1)
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(viewModel?.data.count, 2)
        XCTAssertEqual(viewModel?.data[0].show.name, "ASDFG")
        XCTAssertEqual(viewModel?.data[1].show.name, "ZXCVB")
        XCTAssertEqual(deletedIndexPath, IndexPath(row: 1, section: 0))
    }
}
