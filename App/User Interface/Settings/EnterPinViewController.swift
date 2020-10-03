//
//  EnterPinViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import UIKit

class EnterPinViewController: UIViewController {
    @IBOutlet weak var enterPin1View: EnterPinView?
    @IBOutlet weak var enterPin2View: EnterPinView?
    @IBOutlet weak var enterPin3View: EnterPinView?
    @IBOutlet weak var enterPin4View: EnterPinView?

    var viewModel = EnterPinViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onFinishAuth = { [weak self] in
            self?.enterPin1View?.updateInputStyle(isError: false)
            self?.enterPin2View?.updateInputStyle(isError: false)
            self?.enterPin3View?.updateInputStyle(isError: false)
            self?.enterPin4View?.updateInputStyle(isError: false)
            self?.view.endEditing(true)
            self?.dismiss(animated: true, completion: nil)
        }
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
        enterPin1View?.textField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        enterPin2View?.textField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        enterPin3View?.textField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        enterPin4View?.textField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        viewModel.load()
        OperationQueue.main.addOperation {
            self.enterPin1View?.textField.becomeFirstResponder()
        }
    }
    
    @objc func textFieldEditingChanged(sender: UITextField?) {
        enterPin1View?.updateInputStyle(isError: false)
        enterPin2View?.updateInputStyle(isError: false)
        enterPin3View?.updateInputStyle(isError: false)
        enterPin4View?.updateInputStyle(isError: false)
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
}
