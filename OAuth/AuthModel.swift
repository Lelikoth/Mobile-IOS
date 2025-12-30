//
//  AuthModel.swift
//  OAuth
//
//  Created by user277759 on 12/30/25.
//

import Foundation
import SwiftUI
import GoogleSignIn
import FBSDKLoginKit

@MainActor
final class AuthModel: ObservableObject {
    @Published var user: User?
    @Published var alertMessage: String = ""
    @Published var isShowingAlert: Bool = false
    
    private let api: APIClient
    private let tokenStore = KeychainTokenStore()
    
    init(baseURLString: String = "http://127.0.0.1:5050"){
        self.api = APIClient(baseURL: URL(string: baseURLString)!)
        restoreSession()
    }
    
    func restoreSession() {
        guard let token = tokenStore.loadAccessToke() else {return }
        
        Task {
            do {
                let me: User = try await api.request(path: "/me", method: "GET", body: Optional<LoginRequest>.none, bearerToken: token)
                self.user = me
            } catch {
                tokenStore.clear()
                self.user = nil
            }
        }
    }
    
    func signIn(username: String, password: String) {
        Task{
            do {
                let res: AuthResponse = try await api.request( path: "/login", body: LoginRequest(username: username, password: password)
                )
                try tokenStore.saveAccessToken(res.accessToken)
                self.user = res.user
            } catch {
                showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func reqister(firstName: String, lastName: String, username: String, password: String) {
        Task {
            do {
                let res: AuthResponse = try await api.request(path: "/register", body: RegisterRequest(username: username, password: password, first_name: firstName, last_name: lastName)
                )
                try tokenStore.saveAccessToken(res.accessToken)
                self.user = res.user
            } catch {
                isShowingAlert(message: error.localizedDescription)
            }
        }
    }
    
    func signOut() {
        tokenStore.clear()
        user = nil
    }
    
    func showAlert(message: String) {
        alertMessage = message
        isShowingAlert = true
    }
    
    
    func signInGoogle() {
        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { [weak self] result, error in
            guard let self else { return }
            if let error {
                Task { @MainActor in self.showAlert(message: error.localizedDescription) }
                return
            }
            guard let result else {
                Task { @MainActor in self.showAlert(message: "Google sign-in failed.") }
                return
            }

            let providerUserId = result.user.userID ?? result.user.profile?.email ?? UUID().uuidString
            let token = result.user.accessToken.tokenString

            Task { @MainActor in
                await self.exchangeOAuth(provider: .google, providerUserId: providerUserId, token: token)
            }
        }
    }
    
    
    func signInFb() {
        let manager = LoginManager()
        manager.logIn(permissions: ["public_profile"], from: nil) { [weak self] result, error in
            guard let self else { return }
            if let error {
                Task { @MainActor in self.showAlert(message: error.localizedDescription) }
                return
            }
            guard let result, !result.isCancelled, let tokenString = result.token?.tokenString else {
                Task { @MainActor in self.showAlert(message: "Facebook sign-in cancelled.") }
                return
            }

            let request = GraphRequest(graphPath: "me", parameters: ["fields": "id,first_name,last_name"])
            request.start { _, res, err in
                if let err {
                    Task { @MainActor in self.showAlert(message: err.localizedDescription) }
                    return
                }
                guard let profile = res as? [String: Any],
                      let id = profile["id"] as? String else {
                    Task { @MainActor in self.showAlert(message: "Facebook profile fetch failed.") }
                    return
                }

                Task { @MainActor in
                    await self.exchangeOAuth(provider: .facebook, providerUserId: id, token: tokenString)
                }
            }
        }
    }
    
    private func exchangeOAuth(provider: OAuthProvider, providerUserId: String, token: String) async {
        do {
            let res: AuthREsponse = try await api.request(path: "/oauth", body: OAuthRequest(provider: provider, provider_user_id: providerUserId, token: token)
            )
            try tokenStore.saveAccessToken(res.accessToken)
            self.user = res.user
        } catch {
            showAlert(message: error.localizedDescription)
        }
    }
}
