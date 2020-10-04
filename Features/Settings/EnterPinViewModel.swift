//
//  EnterPinViewModel.swift
//  Features
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
        // If the saved PIN is empty, we will use this view to
        // create a new one
        isNewPin = secretProvider.retrieve(key: .pin).isEmpty
    }

    func enterPin(_ pin: String) {
        if isNewPin {
            // Creating a new PIN, just save and finishes
            secretProvider.save(key: .pin, value: pin)
            onFinishAuth?()
        } else {
            let oldPin = secretProvider.retrieve(key: .pin)
            // Check if the PIN matches the saved one
            if oldPin == pin {
                onFinishAuth?()
            } else {
                onWrongPin?()
            }
        }
    }
}
