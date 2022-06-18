//
//  AuthStore.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-09.
//

import Foundation
import KeychainSwift

protocol AuthStorable {
    func saveToken(token: String)
    func getToken() -> String?
    func deleteAllTokens()
}

class AuthStore: AuthStorable {
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let keychain = KeychainSwift()
    
    
    func saveToken(token: String) {
        keychain.set(token, forKey: accessTokenKey)
    }
    
    func getToken() -> String? {
        return "keychain.get(accessTokenKey)"
    }
    
    func deleteAllTokens() {
        keychain.clear()
    }

    
}
