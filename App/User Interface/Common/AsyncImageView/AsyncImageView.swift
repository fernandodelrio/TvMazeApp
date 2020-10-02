//
//  AsyncImageView.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core
import PromiseKit
import UIKit

class AsyncImageView: UIImageView {
    var viewModel = AsyncImageViewModel()

    func setPlaceholder()  {
        image = viewModel.placeholderImage
        showLoading()
    }

    func loadImage(_ url: URL?) {
        showLoading()
        viewModel
            .loadImage(url)
            .done { [weak self] image in
                self?.hideLoading()
                self?.image = image
            }.cauterize()
    }
}
