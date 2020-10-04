//
//  SettingsViewModel.swift
//  Features
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Core

class SettingsViewModel {
    private lazy var authProvider = Dependency.resolve(AuthProvider.self)
    private lazy var secretProvider = Dependency.resolve(SecretProvider.self)
    private lazy var settingsProvider = Dependency.resolve(SettingsProvider.self)
    var settings = Settings(isAuthActive: false)
    var onBiometricsEnabledChange: ((_ isEnabled: Bool) -> Void)?
    var onBiometricsLabelChange: ((_ text: String) -> Void)?
    var onLoadSwitchState: ((_ isOn: Bool) -> Void)?
    var onCreateNewPin: (() -> Void)?

    func load() {
        // Check if biometrics is enabled
        onBiometricsEnabledChange?(authProvider.authType != .unsupported)
        onBiometricsLabelChange?("Enable %@".localizedWith(authProvider.authType.title))
        onLoadSwitchState?(false)
        // Check if the toggle is on or off
        settingsProvider
            .retrieveSettings()
            .done { [weak self] settings in
                // Reloads the UI
                self?.settings.isAuthActive = settings.isAuthActive
                self?.onLoadSwitchState?(settings.isAuthActive)
            }.cauterize()
    }

    func updateSettings() {
        settings.isAuthActive.toggle()
        // The toggle changed, update the database
        // with the new preference
        settingsProvider.save(settings).cauterize()
        if authProvider.authType == .unsupported, settings.isAuthActive {
            // Turning on the PIN, we need to create a new one
            onCreateNewPin?()
        } else if authProvider.authType == .unsupported, !settings.isAuthActive {
            // Turning off the PIN, just save the current code as empty
            secretProvider.save(key: .pin, value: "")
        }
        // No action needed for biometrics, once the user leaves
        // to background and come back, it should trigger
    }
}
