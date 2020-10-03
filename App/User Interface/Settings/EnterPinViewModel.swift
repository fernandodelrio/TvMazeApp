//
//  EnterPinViewModel.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Core

class EnterPinViewModel {
    private lazy var secretProvider = Dependency.resolve(SecretProvider.self)
    private var isNewPin = false
    var onFinishAuth: (() -> Void)?
    var onWrongPin: (() -> Void)?

    func load() {
        isNewPin = secretProvider.retrieve(key: .pin).isEmpty
    }

    func enterPin(_ pin: String) {
        if isNewPin {
            secretProvider.save(key: .pin, value: pin)
            onFinishAuth?()
        } else {
            let oldPin = secretProvider.retrieve(key: .pin)
            if oldPin == pin {
                onFinishAuth?()
            } else {
                onWrongPin?()
            }
        }
    }
}
