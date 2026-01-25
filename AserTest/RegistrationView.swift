//
//  RegistrationView.swift
//  OAuth
//
//  Created by user277759 on 12/30/25.
//

import SwiftUI

struct RegistrationView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var password = ""

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authModel: AuthModel

    var body: some View {
        VStack(spacing: 24) {
            VStack {
                InputView(
                    text: $firstName,
                    title: "First name:",
                    placeholder: "Enter first name",
                    fieldId: "register.firstName"
                )

                InputView(
                    text: $lastName,
                    title: "Last name:",
                    placeholder: "Enter last name",
                    fieldId: "register.lastName"
                )

                InputView(
                    text: $username,
                    title: "Username:",
                    placeholder: "Enter username",
                    fieldId: "register.username"
                )

                InputView(
                    text: $password,
                    title: "Password:",
                    placeholder: "Enter password",
                    isSecureField: true,
                    fieldId: "register.password"
                )
            }
            .padding(.horizontal)
            .padding(.top, 100)

            Button {
                authModel.register(firstName: firstName, lastName: lastName, username: username, password: password)
            } label: {
                HStack {
                    Text("SIGN UP").fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 30, height: 40)
                .background(Color(.systemBlue))
                .cornerRadius(9.0)
            }
            .padding(.top, 15)
            .accessibilityIdentifier("register.submit")

            Spacer()

            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Have account?")
                    Text("LOG IN").fontWeight(.bold)
                }
            }
            .accessibilityIdentifier("register.goBackLogin")
        }
        .alert("Error", isPresented: $authModel.isShowingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authModel.alertMessage)
        }
    }
}

