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
        setupBindings()
        viewModel.load()
    }

    private func setupBindings() {
        // If biometrics is enabled hides the PIN toggle
        // otherwise show the PIN toggle and hides the
        // biometrics toggle
        viewModel.onBiometricsEnabledChange = { [weak self] isEnabled in
            self?.enableBiometricsStackView?.isHidden = !isEnabled
            self?.enablePinStackView?.isHidden = isEnabled
        }
        // The biometrics label may be different depending on the
        // device. It may be a face ID or a touch ID
        viewModel.onBiometricsLabelChange = { [weak self] text in
            self?.enableBiometricsLabel?.text = text
        }
        // Set the default state for the toggle
        viewModel.onLoadSwitchState = { [weak self] isOn in
            self?.enablePinSwitch?.setOn(isOn, animated: true)
            self?.enableBiometricsSwitch?.setOn(isOn, animated: true)
        }
        // Navigate to the screen to set up a new PIN
        viewModel.onCreateNewPin = { [weak self] in
            self?.performSegue(withIdentifier: "settingsToPinSegue", sender: nil)
        }
    }

    @IBAction func enablePinValueChanged(_ sender: Any) {
        viewModel.updateSettings()
    }

    @IBAction func enableBiometricsValueChanged(_ sender: Any) {
        viewModel.updateSettings()
    }
}