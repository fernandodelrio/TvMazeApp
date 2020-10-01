//
//  EndpointProvider.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import Foundation

public protocol EndpointProvider {
    func url(for endpoint: Endpoint, with args: [CVarArg]) -> URL?
}
