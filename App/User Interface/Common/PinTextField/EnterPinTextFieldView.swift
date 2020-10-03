//
//  EnterPinTextFieldView.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import UIKit

class EnterPinTextFieldView: UITextField {
    var viewModel = EnterPinTextFieldViewModel()

    override func deleteBackward() {
        super.deleteBackward()
        viewModel.backspacePressed()
    }
}
