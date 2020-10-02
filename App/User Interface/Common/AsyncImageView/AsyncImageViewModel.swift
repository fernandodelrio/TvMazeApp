//
//  AsyncImageViewModel.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core
import PromiseKit

class AsyncImageViewModel {
    private let imageCacheProvider = Dependency.resolve(ImageCacheProvider.self)
    private let requestProvider = Dependency.resolve(RequestProvider.self)
    private var loadImageOperation: Operation?
    private var cancelPromise: (() -> Void)?
    lazy var placeholderImage = UIImage(named: "placeholder")
    
    func loadImage(_ url: URL?) -> Promise<UIImage?>  {
        // Cancel any previous operation
        cancelOperations()
        // No url informed, use the placeholder
        guard let url = url else {
            return .value(placeholderImage)
        }
        // If it's already in cache returns it
        if let cached = imageCacheProvider.retrieve(url) {
            return .value(cached)
        }
        return Promise { seal in
            requestProvider
                .request(url: url)
                .done { [weak self] data, _ in
                    self?.cancelPromise = {
                        seal.reject(PMKError.cancelled)
                    }
                    self?.loadImageOperation = BlockOperation {
                        if let downloadedImage = UIImage(data: data) {
                            self?.imageCacheProvider.save(downloadedImage, for: url)
                            seal.fulfill(downloadedImage)
                        } else {
                            seal.fulfill(self?.placeholderImage)
                        }
                    }
                    self?.loadImageOperation.map { OperationQueue.main.addOperation($0) }
                }.recover { [weak self] _ in
                    self?.cancelPromise = {
                        seal.reject(PMKError.cancelled)
                    }
                    self?.loadImageOperation = BlockOperation {
                        seal.fulfill(self?.placeholderImage)
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
