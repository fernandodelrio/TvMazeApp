//
//  MainTabViewModel.swift
//  Features
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Core
import PromiseKit

class MainTabViewModel {
    private lazy var favoriteProvider = Dependency.resolve(FavoriteProvider.self)
    private lazy var settingsProvider = Dependency.resolve(SettingsProvider.self)
    private lazy var authProvider = Dependency.resolve(AuthProvider.self)
    // wasOnBackground indicates if the user went from background
    // (coming back from face id or touch id, triggers the
    // applicationDidBecomeActive event, so this flag is necessary)
    private var wasOnBackground = true
    var onDataChange: ((_ favorites: [Favorite]) -> Void)?
    var onPinRequest: (() -> Void)?
    var onUpdateBiometricsOverlay: ((_ isVisible: Bool) -> Void)?

    func load() {
        // When the database notify about changes, notify that back
        // to the view, to update the favorite badge
        favoriteProvider.onDataChange = { [weak self] favorites in
            self?.onDataChange?(favorites)
        }
        // The first time the app opens, we will not receive a
        // change event from the database, so just read the
        // favorites to update the badge
        favoriteProvider
            .retrieveFavorites()
            .done { [weak self] favorites in
                self?.onDataChange?(favorites)
            }.cauterize()
        becomeActive()
    }

    func becomeActive() {
        guard wasOnBackground else {
            return
        }
        wasOnBackground = false
        authenticate()
    }

    func enterBackground() {
        wasOnBackground = true
    }

    private func authenticate() {
        settingsProvider
            .retrieveSettings()
            .then { [weak self] settings -> Promise<Bool> in
                // If the settings toggle is off, do nothing
                guard let self = self, settings.isAuthActive else {
                    return .value(true)
                }
                // Biometrics auth not supported, request the PIN
                if self.authProvider.authType == .unsupported {
                    self.onPinRequest?()
                } else {
                    // Biometrics supported, show the overlay
                    // and ask authProvider to authenticate
                    self.onUpdateBiometricsOverlay?(true)
                    return self.authProvider.authenticate()
                }
                return .value(true)
            }.done { [weak self] success in
                if success {
                    // Authentication was a success
                    // make sure to hide the biometrics overlay
                    self?.onUpdateBiometricsOverlay?(false)
                } else {
                    // Authentication failed repeat the process
                    self?.authenticate()
                }
            }.cauterize()
    }
}
