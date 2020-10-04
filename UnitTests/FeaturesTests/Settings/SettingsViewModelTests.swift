//
//  SettingsViewModelTests.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import XCTest
@testable import Features
@testable import Core

class SettingsViewModelTests: XCTestCase {
    lazy var injector = TestInjector()
    var viewModel: SettingsViewModel?

    override func setUp() {
        super.setUp()
        injector.load()
        viewModel = SettingsViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        injector.reset()
        viewModel = nil
    }

    func testTouchIdOn() {
        // Setup
        var isBiometricsEnabled: Bool?
        var biometricsLabel: String?
        var isAuthActive: Bool?
        viewModel?
            .onBiometricsEnabledChange = { isBiometricsEnabled = $0 }
        viewModel?
            .onBiometricsLabelChange = { biometricsLabel = $0 }
        viewModel?
            .onLoadSwitchState = { isAuthActive = $0 }
    
        // Given
        MockAuthProvider.mockAuthType = .touchID
        MockSettingsProvider.mockSettings = Settings(isAuthActive: true)
        XCTAssertNil(isBiometricsEnabled)
        XCTAssertNil(biometricsLabel)
        XCTAssertNil(isAuthActive)
        
        // When
        viewModel?.load()
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(isBiometricsEnabled, true)
        XCTAssertEqual(biometricsLabel, "Enable %@".localizedWith(AuthType.touchID.title))
        XCTAssertEqual(isAuthActive, true)
    }

    func testTouchIdOff() {
        // Setup
        var isBiometricsEnabled: Bool?
        var biometricsLabel: String?
        var isAuthActive: Bool?
        viewModel?
            .onBiometricsEnabledChange = { isBiometricsEnabled = $0 }
        viewModel?
            .onBiometricsLabelChange = { biometricsLabel = $0 }
        viewModel?
            .onLoadSwitchState = { isAuthActive = $0 }
    
        // Given
        MockAuthProvider.mockAuthType = .touchID
        MockSettingsProvider.mockSettings = Settings(isAuthActive: false)
        XCTAssertNil(isBiometricsEnabled)
        XCTAssertNil(biometricsLabel)
        XCTAssertNil(isAuthActive)
        
        // When
        viewModel?.load()
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(isBiometricsEnabled, true)
        XCTAssertEqual(biometricsLabel, "Enable %@".localizedWith(AuthType.touchID.title))
        XCTAssertEqual(isAuthActive, false)
    }

    func testFaceIdOn() {
        // Setup
        var isBiometricsEnabled: Bool?
        var biometricsLabel: String?
        var isAuthActive: Bool?
        viewModel?
            .onBiometricsEnabledChange = { isBiometricsEnabled = $0 }
        viewModel?
            .onBiometricsLabelChange = { biometricsLabel = $0 }
        viewModel?
            .onLoadSwitchState = { isAuthActive = $0 }
    
        // Given
        MockAuthProvider.mockAuthType = .faceID
        MockSettingsProvider.mockSettings = Settings(isAuthActive: true)
        XCTAssertNil(isBiometricsEnabled)
        XCTAssertNil(biometricsLabel)
        XCTAssertNil(isAuthActive)
        
        // When
        viewModel?.load()
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(isBiometricsEnabled, true)
        XCTAssertEqual(biometricsLabel, "Enable %@".localizedWith(AuthType.faceID.title))
        XCTAssertEqual(isAuthActive, true)
    }

    func testFaceIdOff() {
        // Setup
        var isBiometricsEnabled: Bool?
        var biometricsLabel: String?
        var isAuthActive: Bool?
        viewModel?
            .onBiometricsEnabledChange = { isBiometricsEnabled = $0 }
        viewModel?
            .onBiometricsLabelChange = { biometricsLabel = $0 }
        viewModel?
            .onLoadSwitchState = { isAuthActive = $0 }
    
        // Given
        MockAuthProvider.mockAuthType = .faceID
        MockSettingsProvider.mockSettings = Settings(isAuthActive: false)
        XCTAssertNil(isBiometricsEnabled)
        XCTAssertNil(biometricsLabel)
        XCTAssertNil(isAuthActive)
        
        // When
        viewModel?.load()
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(isBiometricsEnabled, true)
        XCTAssertEqual(biometricsLabel, "Enable %@".localizedWith(AuthType.faceID.title))
        XCTAssertEqual(isAuthActive, false)
    }

    func testPinOn() {
        // Setup
        var isBiometricsEnabled: Bool?
        var isAuthActive: Bool?
        viewModel?
            .onBiometricsEnabledChange = { isBiometricsEnabled = $0 }
        viewModel?
            .onLoadSwitchState = { isAuthActive = $0 }
    
        // Given
        MockAuthProvider.mockAuthType = .unsupported
        MockSettingsProvider.mockSettings = Settings(isAuthActive: true)
        XCTAssertNil(isBiometricsEnabled)
        XCTAssertNil(isAuthActive)
        
        // When
        viewModel?.load()
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(isBiometricsEnabled, false)
        XCTAssertEqual(isAuthActive, true)
    }

    func testPinOff() {
        // Setup
        var isBiometricsEnabled: Bool?
        var isAuthActive: Bool?
        viewModel?
            .onBiometricsEnabledChange = { isBiometricsEnabled = $0 }
        viewModel?
            .onLoadSwitchState = { isAuthActive = $0 }
    
        // Given
        MockAuthProvider.mockAuthType = .unsupported
        MockSettingsProvider.mockSettings = Settings(isAuthActive: false)
        XCTAssertNil(isBiometricsEnabled)
        XCTAssertNil(isAuthActive)
        
        // When
        viewModel?.load()
        wait(timeout: 0.5)
        
        // Then
        XCTAssertEqual(isBiometricsEnabled, false)
        XCTAssertEqual(isAuthActive, false)
    }

    func testCreateNewPin() {
        // Setup
        var isCreateNewPinCalled: Bool?
        viewModel?
            .onCreateNewPin = { isCreateNewPinCalled = true }

        // Given
        viewModel?.settings = Settings(isAuthActive: false)
        MockAuthProvider.mockAuthType = .unsupported
        XCTAssertNil(isCreateNewPinCalled)

        // When
        viewModel?.updateSettings()
        wait(timeout: 0.5)

        // Then
        XCTAssertEqual(isCreateNewPinCalled, true)
    }

    func testClearPin() {
        // Given
        viewModel?.settings = Settings(isAuthActive: true)
        MockAuthProvider.mockAuthType = .unsupported
        MockSecretProvider.mockSecrets[SecretKey.pin.rawValue] = "1234"
        MockSecretProvider.mockSaveCalled = false

        // When
        viewModel?.updateSettings()
        wait(timeout: 0.5)

        // Then
        XCTAssertEqual(MockSecretProvider.mockSaveCalled, true)
        XCTAssertEqual(MockSecretProvider.mockSecrets[SecretKey.pin.rawValue], "")
    }
}
