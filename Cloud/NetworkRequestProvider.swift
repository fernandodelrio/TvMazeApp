//
//  NetworkRequestProvider.swift
//  Cloud
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import Core
import PromiseKit

public class NetworkRequestProvider: RequestProvider {
    private lazy var endpointProvider = Dependency.resolve(EndpointProvider.self)

    public init() {
    }

    public func request(endpoint: Endpoint, with args: CVarArg...) -> Promise<NetworkResponse> {
        guard let url = endpointProvider.url(for: endpoint, with: args) else {
            return .init(error: NetworkError.invalidUrl)
        }
        return .retry(times: 3) {
            self.dataTaskPromise(url: url)
        }
    }

    public func request(url: URL) -> Promise<NetworkResponse> {
        .retry(times: 3) {
            self.dataTaskPromise(url: url)
        }
    }

    private func dataTaskPromise(url: URL) -> Promise<NetworkResponse> {
        Promise { seal in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    seal.reject(NetworkError.dataNotFound)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = StatusCode(rawValue: httpResponse.statusCode) ?? .other
                    if statusCode == .tooManyRequests {
                        seal.reject(NetworkError.rateLimitAchieved)
                    } else {
                        seal.fulfill((data, statusCode))
                    }
                } else {
                    seal.fulfill((data, .other))
                }
            }
            task.resume()
        }
    }
}
