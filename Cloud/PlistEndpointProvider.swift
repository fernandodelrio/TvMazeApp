//
//  PlistEndpointProvider.swift
//  Cloud
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import Core

// This class retrieves the endpoints from a plist file
public class PlistEndpointProvider: EndpointProvider {
    private let endpointsPlist = {
        Bundle(for: PlistEndpointProvider.self)
            .path(forResource: "Endpoints", ofType: "plist")
            .map { NSDictionary(contentsOfFile: $0) ?? [:] }
    }()

    public init() {
    }

    public func url(for endpoint: Endpoint, with args: [CVarArg]) -> URL? {
        let formatEndpoint = endpointsPlist?[endpoint.rawValue] as? String ?? ""
        return URL(string: String(format: formatEndpoint, arguments: args))
    }
}
