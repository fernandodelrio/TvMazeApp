//
//  SettingsViewModel.swift
//  App
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
        settings.isAuthActive = authProvider.authType != .unsupported
        onBiometricsEnabledChange?(settings.isAuthActive)
        onBiometricsLabelChange?("Enable \(authProvider.authType.localized)")
        onLoadSwitchState?(false)
        settingsProvider
            .retrieveSettings()
            .done { [weak self] settings in
                self?.settings.isAuthActive = settings.isAuthActive
                self?.onLoadSwitchState?(settings.isAuthActive)
            }.cauterize()
    }

    func updateSettings() {
        settings.isAuthActive.toggle()
        settingsProvider.save(settings).cauterize()
        if authProvider.authType == .unsupported, settings.isAuthActive {
            onCreateNewPin?()
        } else if authProvider.authType == .unsupported, !settings.isAuthActive {
            secretProvider.save(key: .pin, value: "")
        }
    }
}
