//
//  Injector.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import Auth
import Core
import Cloud
import Database
import Secure

class Injector {
    func load() {
        Dependency.register(ImageCacheProvider.self) {
            NSImageCacheProvider()
        }

        Dependency.register(EndpointProvider.self) {
            PlistEndpointProvider()
        }

        Dependency.register(RequestProvider.self) {
            NetworkRequestProvider()
        }

        Dependency.register(ShowProvider.self) {
            NetworkShowProvider()
        }

        Dependency.register(EpisodeProvider.self) {
            NetworkEpisodeProvider()
        }

        Dependency.register(PersonProvider.self) {
            NetworkPersonProvider()
        }

        Dependency.register(FavoriteProvider.self) {
            CoreDataFavoriteProvider()
        }

        Dependency.register(SettingsProvider.self) {
            CoreDataSettingsProvider()
        }

        Dependency.register(SecretProvider.self) {
            KeychainSecretProvider()
        }

        Dependency.register(AuthProvider.self) {
            BiometricsAuthProvider()
        }
    }
}
