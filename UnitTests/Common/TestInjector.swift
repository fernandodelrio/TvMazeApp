//
//  TestInjector.swift
//  UnitTests
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import Foundation
@testable import Auth
@testable import Cloud
@testable import Core
@testable import Database
@testable import Secure

class TestInjector {
    func reset() {
        Dependency.unregisterAll()
    }

    func load() {
        Dependency.register(ImageCacheProvider.self) {
            MockImageCacheProvider()
        }

        Dependency.register(EndpointProvider.self) {
            MockEndpointProvider()
        }

        Dependency.register(RequestProvider.self) {
            MockRequestProvider()
        }

        Dependency.register(ShowProvider.self) {
            MockShowProvider()
        }

        Dependency.register(EpisodeProvider.self) {
            MockEpisodeProvider()
        }

        Dependency.register(PersonProvider.self) {
            MockPersonProvider()
        }

        Dependency.register(FavoriteProvider.self) {
            MockFavoriteProvider()
        }

        Dependency.register(SettingsProvider.self) {
            MockSettingsProvider()
        }

        Dependency.register(SecretProvider.self) {
            MockSecretProvider()
        }

        Dependency.register(AuthProvider.self) {
            MockAuthProvider()
        }
    }
}
