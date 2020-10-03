//
//  EnterPinTextFieldViewModel.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Foundation

class EnterPinTextFieldViewModel {
    var onBackspacePressed: (() -> Void)?

    func backspacePressed() {
        onBackspacePressed?()
    }
}
