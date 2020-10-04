//
//  UIView+Message.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/2/20.
//

import UIKit

public extension UIView {
    // Shows a message label in the middle of the screen
    func showMessageLabel(_ message: String) {
        hideMessageLabel()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tag = AppConstants.messageLabelTag
        label.text = message
        let centerXConstraint = label.centerXAnchor.constraint(equalTo: centerXAnchor)
        let centerYConstraint = label.centerYAnchor.constraint(equalTo: centerYAnchor)
        addSubview(label)
        addConstraints([centerXConstraint, centerYConstraint])
        layoutIfNeeded()
    }

    // Hides the message label
    func hideMessageLabel() {
        subviews
            .compactMap { $0 as? UILabel }
            .filter { $0.tag == AppConstants.messageLabelTag }
            .forEach { $0.removeFromSuperview() }
        layoutIfNeeded()
    }
}
