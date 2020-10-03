//
//  SecretProvider.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

public protocol SecretProvider {
    func save(key: SecretKey, value: String)
    func retrieve(key: SecretKey) -> String
}
