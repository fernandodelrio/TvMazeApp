//
//  EnterPinTextFieldViewModel.swift
//  Features
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Foundation

class EnterPinTextFieldViewModel {
    var onBackspacePressed: (() -> Void)?

    // Just call back the provided closure
    func backspacePressed() {
        onBackspacePressed?()
    }
}
