//
//  KeychainTokenStore.swift
//  OAuth
//
//  Created by user277759 on 12/30/25.
//

import Foundation
import Security

final class KeychainTokenStore {
    private let service = "OAuthPrototype"
    private let account = "accessToken"
    
    func saveAccessToken(_ token: String) throws {
        let data = Data(token.uft8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let add: [String: Any] = query.merging([
            kSecValueData as String: data
        ]) { $1 }
        
        let status = SecItemAdd(add as CFDictionary, nil)
        guard status == errSecSuccess else {throw NSError(domain: "Keychain", code: Int(status))}
    }
    
    func loadAccessToke() -> String? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else {return nil}
        return String(data: data, encoding: .uft8)
    }
    
    func clear() {
        let query: [ String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
