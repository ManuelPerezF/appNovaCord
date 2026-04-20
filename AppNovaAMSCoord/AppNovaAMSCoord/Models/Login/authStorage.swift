//
//  authStorage.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 02/12/25.
//

import Foundation

class AuthStorage {
    static let shared = AuthStorage()
    
    private let tokenKey = "jwtToken"

    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }

    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
