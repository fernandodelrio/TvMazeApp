//
//  UIImage+AsyncLoad.swift
//  TvMaze
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import PromiseKit
import UIKit

private let imageCacheProvider = Dependency.resolve(ImageCacheProvider.self)
private let requestProvider = Dependency.resolve(RequestProvider.self)

public extension UIImageView {
    func loadUrl(_ url: URL) {
        // If it's already in cache returns it
        if let cached = imageCacheProvider.retrieve(url) {
            image = cached
            return
        }
        // Otherwise, download and save in the cache
        showLoading()
        
        // Placeholder used if there's an issue loading the image
        let placeholder = UIImage(named: "placeholder")
        
        requestProvider
            .request(url: url)
            .done { [weak self] data, _ in
                OperationQueue.main.addOperation {
                    if let downloadedImage = UIImage(data: data) {
                        self?.image = downloadedImage
                        imageCacheProvider.save(downloadedImage, for: url)
                    } else {
                        self?.image = placeholder
                    }
                    self?.hideLoading()
                }
            }.recover { [weak self] _ in
                self?.image = placeholder
                self?.hideLoading()
            }
    }
}
