//
//  EnterPinTextFieldView.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import UIKit

class EnterPinTextFieldView: UITextField {
    var viewModel = EnterPinTextFieldViewModel()

    // Get the backspace event to be able to trigger
    // the deletion on the pin input
    override func deleteBackward() {
        super.deleteBackward()
        viewModel.backspacePressed()
    }
}
