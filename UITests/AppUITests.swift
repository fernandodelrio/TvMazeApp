//
//  AppUITests.swift
//  AppUITests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import XCTest

class AppUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func testPeopleToEpisodeFlow() {
        // Launch
        let app = XCUIApplication()
        app.launch()
        // Navigate to people tab
        let peopleTab = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(peopleTab.waitForExistence(timeout: 5))
        peopleTab.tap()
        // Search for a person
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("David Tennant")
        let searchButton = app.buttons
            .matching(identifier: "Search")
            .firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchButton.tap()
        // Navigate to person details
        let personCell = app.tables.cells.staticTexts["David Tennant"]
        XCTAssertTrue(personCell.waitForExistence(timeout: 5))
        personCell.tap()
        // Get serie cell
        let serieCell = app.tables.cells.containing(.staticText, identifier: "Doctor Who").firstMatch
        XCTAssertTrue(serieCell.waitForExistence(timeout: 5))
        // Validate it's not favorited
        XCTAssertEqual(serieCell.buttons.firstMatch.label, "star")
        // Favorite it
        serieCell.buttons.firstMatch.tap()
        // Navigate to details
        serieCell.tap()
        let detailsSerieButton = app.buttons.matching(identifier: "star filled").firstMatch
        // Validate it's favorited
        XCTAssertTrue(detailsSerieButton.waitForExistence(timeout: 5))
        // Unfavorite it
        detailsSerieButton.tap()
        // Validate episode exists
        let episodeCell = app.tables.cells.staticTexts["Rose"]
        XCTAssertTrue(episodeCell.waitForExistence(timeout: 5))
        // Navigate to episode
        episodeCell.tap()
        let summary = "Rose Tyler meets a mysterious stranger called the Doctor, and realises Earth is in danger."
        let summaryElement = app.staticTexts
            .element(matching: NSPredicate(format: "label CONTAINS %@", summary))
        // Validate the summary is correct
        XCTAssertTrue(summaryElement.waitForExistence(timeout: 5))
    }
}
