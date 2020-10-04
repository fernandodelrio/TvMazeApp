//
//  EnterPinView.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Core
import UIKit

class EnterPinView: UIView {
    // The textfield used to enter the pin
    lazy var textField: EnterPinTextFieldView = {
        let view = EnterPinTextFieldView()
        view.textAlignment = .center
        view.borderStyle = .none
        view.isSecureTextEntry = true
        view.keyboardType = .numberPad
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextFieldConstraints()
        setupInputStyle()
    }

    // Adding shadow and border to the container view
    // If it's an error, show in a different color
    func updateInputStyle(isError: Bool) {
        layer.shadowColor = isError ? AppConstants.defaultErrorColor : AppConstants.defaultBorderColor
        layer.borderColor = isError ? AppConstants.defaultErrorColor : AppConstants.defaultBorderColor
    }

    // Adding corner radius to the text field
    private func setupInputStyle() {
        layer.cornerRadius = AppConstants.inputCornerRadius
        layer.shadowOffset = AppConstants.defaultShadowOffset
        layer.shadowRadius = AppConstants.defaultShadowRadius
        layer.shadowOpacity = AppConstants.defaultShadowOpacity
        layer.borderWidth = AppConstants.defaultBorderWidth
        clipsToBounds = false
        updateInputStyle(isError: false)
    }

    private func setupTextFieldConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
