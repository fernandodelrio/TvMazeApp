//
//  MainTabViewModel.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Core
import PromiseKit

class MainTabViewModel {
    private lazy var favoriteProvider = Dependency.resolve(FavoriteProvider.self)
    private lazy var settingsProvider = Dependency.resolve(SettingsProvider.self)
    private lazy var authProvider = Dependency.resolve(AuthProvider.self)
    private var wasOnBackground = true
    var onDataChange: ((_ favorites: [Favorite]) -> Void)?
    var onPinRequest: (() -> Void)?
    var onUpdateAuthLayer: ((_ isVisible: Bool) -> Void)?

    func load() {
        favoriteProvider.onDataChange = { [weak self] favorites in
            self?.onDataChange?(favorites)
        }
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
                guard let self = self, settings.isAuthActive else {
                    return .value(true)
                }
                if self.authProvider.authType == .unsupported {
                    self.onPinRequest?()
                } else  {
                    self.onUpdateAuthLayer?(true)
                    return self.authProvider.authenticate()
                }
                return .value(true)
            }.done { [weak self] success in
                if success {
                    self?.onUpdateAuthLayer?(false)
                } else {
                    self?.authenticate()
                }
            }.cauterize()
    }
}
