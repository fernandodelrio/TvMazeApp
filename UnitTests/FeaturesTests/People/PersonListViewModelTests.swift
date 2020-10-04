//
//  PersonListViewModelTests.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import XCTest
@testable import Features
@testable import Core

class PersonListViewModelTests: XCTestCase {
    lazy var injector = TestInjector()
    var viewModel: PersonListViewModel?

    override func setUp() {
        super.setUp()
        injector.load()
        viewModel = PersonListViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        injector.reset()
        viewModel = nil
    }

    func testSearchForPerson() {
        // Setup
        var isDataChangeCalled: Bool?
        var isLoading: Bool?
        viewModel?
            .onDataChange = { isDataChangeCalled = true }
        viewModel?
            .onLoadingChange = { isLoading = $0 }
        var person = Person()
        person.id = 123
        MockPersonProvider.mockPeople = [person]

        // Given
        XCTAssertEqual(viewModel?.data.count, 0)
        XCTAssertNil(isDataChangeCalled)
        XCTAssertNil(isLoading)

        // When
        viewModel?.searchTextDidEndEditing("some search")
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(viewModel?.data.first?.id, 123)
        XCTAssertEqual(isDataChangeCalled, true)
        XCTAssertEqual(isLoading, false)
    }
}
