//
//  AsyncImageViewModel.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core
import PromiseKit

class AsyncImageViewModel {
    // Cache the images to avoid downloading the same image twice
    private let imageCacheProvider = Dependency.resolve(ImageCacheProvider.self)
    private let requestProvider = Dependency.resolve(RequestProvider.self)
    // An operation that can be cancelled, in case the cell is
    // not visible anymore and it's downloading the image
    private var loadImageOperation: Operation?
    private var cancelPromise: (() -> Void)?

    func loadImage(_ url: URL?) -> Promise<UIImage?> {
        // Cancel any previous operation
        cancelOperations()
        // No url informed, use the placeholder
        guard let url = url else {
            return .value(AppConstants.placeholderImage)
        }
        // If it's already in cache returns it
        if let cached = imageCacheProvider.retrieve(url) {
            return .value(cached)
        }
        return Promise { seal in
            // First request the URL
            requestProvider
                .request(url: url)
                .done { [weak self] data, _ in
                    self?.cancelPromise = {
                        seal.reject(PMKError.cancelled)
                    }
                    self?.loadImageOperation = BlockOperation {
                        if let downloadedImage = UIImage(data: data) {
                            // If the data can be parsed to an image
                            // save in the cache and complete
                            self?.imageCacheProvider.save(downloadedImage, for: url)
                            seal.fulfill(downloadedImage)
                        } else {
                            // Otherwise, returns the placeholder
                            seal.fulfill(AppConstants.placeholderImage)
                        }
                    }
                    self?.loadImageOperation.map { OperationQueue.main.addOperation($0) }
                }.recover { [weak self] _ in
                    // In case of errors, just returns the placeholder image
                    self?.cancelPromise = {
                        seal.reject(PMKError.cancelled)
                    }
                    self?.loadImageOperation = BlockOperation {
                        seal.fulfill(AppConstants.placeholderImage)
                    }
                    self?.loadImageOperation.map { OperationQueue.main.addOperation($0) }
                }
        }
    }

    private func cancelOperations() {
        loadImageOperation?.cancel()
        cancelPromise?()
    }
}
