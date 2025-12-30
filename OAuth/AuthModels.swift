//
//  AuthModels.swift
//  OAuth
//
//  Created by user277759 on 12/30/25

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct RegisterRequest: Codable {
    let username: String
    let password: String
    let first_name: String
    let last_name: String
}

enum OAuthProvider: String, Codable {
    case google
    case facebook
}


struct OAuthRequest: Codable {
    let provider: OAuthProvider
    let provider_user_id: String
    let token: String
}


struct AuthResponse: Codable{
    let user: User
    let accessToken: String
}
