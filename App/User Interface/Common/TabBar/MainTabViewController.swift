//
//  MainTabViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import UIKit

class MainTabViewController: UITabBarController {
    enum Tabs: Int {
        case shows
        case people
        case favorites
        case settings
    }

    lazy var authenticationLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()

    lazy var viewModel = MainTabViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAuthenticationLayerView()
        viewModel.onDataChange = { [weak self] favorites in
            let badgeValue = favorites.isEmpty ? nil : "\(favorites.count)"
            self?.tabBar.items?[Tabs.favorites.rawValue].badgeValue = badgeValue
        }
        viewModel.onPinRequest = { [weak self] in
            self?.performSegue(withIdentifier: "mainTabToPinSegue", sender: nil)
        }
        viewModel.onUpdateAuthLayer = { [weak self] isVisible in
            self?.authenticationLayerView.isHidden = !isVisible
        }
        viewModel.load()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
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

    private func setupAuthenticationLayerView() {
        view.addSubview(authenticationLayerView)
        authenticationLayerView.translatesAutoresizingMaskIntoConstraints = false
        authenticationLayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        authenticationLayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        authenticationLayerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        authenticationLayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
