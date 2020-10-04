//
//  Dependency.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//

import Foundation

// Manages the dependency injection strategy
public class Dependency {
    // The dependency registry
    private static var registry: [String: Any] = [:]

    // Associate an abstract type to a concrete implementation
    // and store in the registry
    public static func register<T>(_ type: T.Type, value: @escaping () -> T) {
        let key = String(describing: type)
        registry[key] = value
    }

    // Resolves a abstract type to its concrete implementation
    // (need to make sure all dependencies are properly
    // registered in the app or unit test)
    public static func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        if let resolution = registry[key] as? () -> T {
            return resolution()
        } else {
            fatalError("Missing register dependency \(key)")
        }
    }
}
