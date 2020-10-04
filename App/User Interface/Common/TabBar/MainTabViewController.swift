//
//  MainTabViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Core
import UIKit

class MainTabViewController: UITabBarController {
    // This view hides the app content, when
    // touch ID or face ID is being validated
    lazy var biometricsOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()

    lazy var viewModel = MainTabViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.items?
            .enumerated()
            .forEach { index, item in
                let tab = MainTab(rawValue: index)
                item.title = tab?.title ?? ""
            }
        setupBiometricsOverlayView()
        setupBindings()
        setupListeners()
        viewModel.load()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func applicationDidEnterBackground() {
        viewModel.enterBackground()
    }

    @objc private func applicationDidBecomeActive() {
        viewModel.becomeActive()
    }

    private func setupBindings() {
        // Listen to changes on favorites database
        // update the tab badge accordingly
        viewModel.onDataChange = { [weak self] favorites in
            let badgeValue = favorites.isEmpty ? nil : "\(favorites.count)"
            self?.tabBar.items?[MainTab.favorites.rawValue].badgeValue = badgeValue
        }
        // Navigate to enter PIN and secure the user content
        viewModel.onPinRequest = { [weak self] in
            self?.performSegue(withIdentifier: "mainTabToPinSegue", sender: nil)
        }
        // Display the overlay before touch ID or face ID validation
        viewModel.onUpdateBiometricsOverlay = { [weak self] isVisible in
            self?.biometricsOverlayView.isHidden = !isVisible
        }
    }

    private func setupListeners() {
        // The authentication validations will happen when the user opens the app
        // for the first time or come back from background
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }

    private func setupBiometricsOverlayView() {
        view.addSubview(biometricsOverlayView)
        biometricsOverlayView.translatesAutoresizingMaskIntoConstraints = false
        biometricsOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        biometricsOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        biometricsOverlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        biometricsOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
