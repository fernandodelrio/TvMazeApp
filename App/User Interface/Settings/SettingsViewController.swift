//
//  SettingsViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var enablePinStackView: UIStackView?
    @IBOutlet weak var enableBiometricsStackView: UIStackView?
    @IBOutlet weak var enableBiometricsLabel: UILabel?
    @IBOutlet weak var enablePinSwitch: UISwitch?
    @IBOutlet weak var enableBiometricsSwitch: UISwitch?

    var viewModel = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onBiometricsEnabledChange = { [weak self] isEnabled in
            self?.enableBiometricsStackView?.isHidden = !isEnabled
            self?.enablePinStackView?.isHidden = isEnabled
        }
        viewModel.onBiometricsLabelChange = { [weak self] text in
            self?.enableBiometricsLabel?.text = text
        }
        viewModel.onLoadSwitchState = { [weak self] isOn in
            self?.enablePinSwitch?.setOn(isOn, animated: true)
            self?.enableBiometricsSwitch?.setOn(isOn, animated: true)
        }
        viewModel.onCreateNewPin = { [weak self] in
            self?.performSegue(withIdentifier: "settingsToPinSegue", sender: nil)
        }
        viewModel.load()
    }

    @IBAction func enablePinValueChanged(_ sender: Any) {
        viewModel.updateSettings()
    }

    @IBAction func enableBiometricsValueChanged(_ sender: Any) {
        viewModel.updateSettings()
    }
}
