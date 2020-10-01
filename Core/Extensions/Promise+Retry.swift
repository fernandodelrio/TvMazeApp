//
//  Promise+Retry.swift
//  TvMaze
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import PromiseKit

public extension Promise {
    @discardableResult static func retry<T>(times: Int, wait: TimeInterval = 5.0, body: @escaping () -> Promise<T>) -> Promise<T> {
        var attempts = times
        func attempt() -> Promise<T> {
            return body().recover { error -> Promise<T> in
                attempts -= 1
                guard attempts > 0 else { throw error }
                return after(seconds: wait).then(attempt)
            }
        }
        return attempt()
    }
}
