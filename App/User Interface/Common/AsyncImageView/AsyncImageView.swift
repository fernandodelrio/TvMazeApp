//
//  AsyncImageView.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core
import PromiseKit
import UIKit

class AsyncImageView: UIView {
    var viewModel = AsyncImageViewModel()
    // The imageView inside the view
    // We need a container around
    // to be able to add shadow and
    // round corners simultaneously
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = AppConstants.imageCornerRadius
        view.clipsToBounds = true
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
        setupImageViewConstraints()
    }

    // Showing a placeholder with a loading on it
    // until the image can be loaded properly.
    // This method will be used while the table view
    // is getting scrolled, avoiding flickering
    // by the cell reuse + async load
    func setPlaceholder()  {
        imageView.image = AppConstants.placeholderImage
        showLoading()
    }

    // Loads the image asynchronously
    // Displays a load and hides it when
    // the process finishes
    func loadImage(_ url: URL?) {
        showLoading()
        viewModel
            .loadImage(url)
            .done { [weak self] image in
                self?.hideLoading()
                self?.imageView.image = image
            }.cauterize()
    }

    func setupShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = AppConstants.defaultShadowOffset
        layer.shadowRadius = AppConstants.defaultShadowRadius
        layer.shadowOpacity = AppConstants.defaultShadowOpacity
        clipsToBounds = false
    }

    func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
