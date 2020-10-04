//
//  EnterPinViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import UIKit

class EnterPinViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var enterPin1View: EnterPinView?
    @IBOutlet weak var enterPin2View: EnterPinView?
    @IBOutlet weak var enterPin3View: EnterPinView?
    @IBOutlet weak var enterPin4View: EnterPinView?

    var viewModel = EnterPinViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel?.text = "Enter the PIN to continue".localized
        setupBindings()
        setupTargetActions()
        // Give focus to the first PIN digit
        enterPin1View?.textField.becomeFirstResponder()
        viewModel.load()
    }
    
    @objc func textFieldEditingChanged(sender: UITextField?) {
        // Clear the input style
        enterPin1View?.updateInputStyle(isError: false)
        enterPin2View?.updateInputStyle(isError: false)
        enterPin3View?.updateInputStyle(isError: false)
        enterPin4View?.updateInputStyle(isError: false)
        // Advance the PIN digit. If it's the last
        // digit, validate and ask view model to handle
        switch sender {
        case enterPin1View?.textField:
            enterPin2View?.textField.becomeFirstResponder()
        case enterPin2View?.textField:
            enterPin3View?.textField.becomeFirstResponder()
        case enterPin3View?.textField:
            enterPin4View?.textField.becomeFirstResponder()
        case enterPin4View?.textField:
            let code1 = enterPin1View?.textField.text ?? "0"
            let code2 = enterPin2View?.textField.text ?? "0"
            let code3 = enterPin3View?.textField.text ?? "0"
            let code4 = enterPin4View?.textField.text ?? "0"
            viewModel.enterPin("\(code1)\(code2)\(code3)\(code4)")
        default: break
        }
    }

    private func setupTargetActions() {
        enterPin1View?.textField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        enterPin2View?.textField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        enterPin3View?.textField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        enterPin4View?.textField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
    }

    private func setupBindings() {
        // Auth succeeded, clear the input style,
        // close the keyboard and dismiss the
        // view controller
        viewModel.onFinishAuth = { [weak self] in
            self?.enterPin1View?.updateInputStyle(isError: false)
            self?.enterPin2View?.updateInputStyle(isError: false)
            self?.enterPin3View?.updateInputStyle(isError: false)
            self?.enterPin4View?.updateInputStyle(isError: false)
            self?.view.endEditing(true)
            self?.dismiss(animated: true, completion: nil)
        }
        // Wrong pin, clear the text, update the style
        // to demonstrate error and focus on the
        // first PIN digit
        viewModel.onWrongPin = { [weak self] in
            self?.enterPin1View?.textField.text = ""
            self?.enterPin2View?.textField.text = ""
            self?.enterPin3View?.textField.text = ""
            self?.enterPin4View?.textField.text = ""
            self?.enterPin1View?.textField.becomeFirstResponder()
            self?.enterPin1View?.updateInputStyle(isError: true)
            self?.enterPin2View?.updateInputStyle(isError: true)
            self?.enterPin3View?.updateInputStyle(isError: true)
            self?.enterPin4View?.updateInputStyle(isError: true)
        }
        // When backspace is pressed, navigate back to the previous field
        enterPin2View?.textField.viewModel.onBackspacePressed = { [weak self] in
            self?.enterPin1View?.textField.text = ""
            self?.enterPin1View?.textField.becomeFirstResponder()
        }
        enterPin3View?.textField.viewModel.onBackspacePressed = { [weak self] in
            self?.enterPin2View?.textField.text = ""
            self?.enterPin2View?.textField.becomeFirstResponder()
        }
        enterPin4View?.textField.viewModel.onBackspacePressed = { [weak self] in
            self?.enterPin3View?.textField.text = ""
            self?.enterPin3View?.textField.becomeFirstResponder()
        }
    }
}
