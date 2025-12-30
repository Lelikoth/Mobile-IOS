//
//  Untitled.swift
//  OAuth
//
//  Created by user277759 on 12/30/25.
//

import SwiftUI
import GoogleSignInSwift

struct OAuthView: View {
    @EnvironmentObject var authModel: AuthModel

    var body: some View {
        VStack(spacing: 12) {
            GoogleSignInButton(action: authModel.signInGoogle)
                .accessibilityIdentifier("GoogleSignInButton")
                .padding(.horizontal)

            Button {
                authModel.signInFb()
            } label: {
                Text("Facebook login")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }
}
