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
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = .init(width: 3.0, height: 3.0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.5
        clipsToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    func setPlaceholder()  {
        imageView.image = viewModel.placeholderImage
        showLoading()
    }

    func loadImage(_ url: URL?) {
        showLoading()
        viewModel
            .loadImage(url)
            .done { [weak self] image in
                self?.hideLoading()
                self?.imageView.image = image
            }.cauterize()
    }
}
