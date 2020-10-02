//
//  UIView+Loading.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import UIKit

public extension UIView {
    func showLoading() {
        hideLoading()
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraint = activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        let centerYConstraint = activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)

        addSubview(activityIndicator)
        addConstraints([centerXConstraint, centerYConstraint])
        layoutIfNeeded()
    }

    func hideLoading() {
        subviews
            .compactMap { $0 as? UIActivityIndicatorView }
            .forEach { $0.removeFromSuperview() }
        layoutIfNeeded()
    }
}
