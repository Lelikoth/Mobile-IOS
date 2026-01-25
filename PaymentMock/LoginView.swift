//
//  LoginView.swift
//  OAuth
//
//  Created by user277759 on 12/30/25.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @EnvironmentObject var authModel: AuthModel
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack {
                    InputView(text: $username, title: "Username:", placeholder: "Enter username")
                    InputView(text: $password, title: "Password:", placeholder: "Enter password", isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 100)

                Button {
                    authModel.signIn(username: username, password: password)
                } label: {
                    HStack {
                        Text("SIGN IN").fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 40)
                    .background(Color(.systemBlue))
                    .cornerRadius(9.0)
                }
                .padding(.top, 15)

                Spacer()

                OAuthView()

                Spacer()

                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack {
                        Text("Don't have account?")
                        Text("SIGN UP").fontWeight(.bold)
                    }
                }
            }
            .alert("Error", isPresented: $authModel.isShowingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authModel.alertMessage)
            }
        }
    }
}
