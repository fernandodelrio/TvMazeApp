//
//  KeychainSecretProvider.swift
//  Secure
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Core

// Store sensitive information in the keychain
public class KeychainSecretProvider: SecretProvider {
    public init() {
    }

    public func save(key: SecretKey, value: String) {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: value.data(using: .utf8) ?? Data()
        ] as [String: Any]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    public func retrieve(key: SecretKey) -> String {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == noErr {
            let data = (dataTypeRef as? Data?) ?? Data()
            let string = data.map { String(data: $0, encoding: .utf8) ?? "" }
            return string ?? ""
        } else {
            return ""
        }
    }

    private func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)
        let string: String = cfStr as String
        return string
    }
}
