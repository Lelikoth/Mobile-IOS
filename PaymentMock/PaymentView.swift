//
//  PaymentView.swift
//  OAuth
//
//  Created by user277759 on 1/25/26.
//

import SwiftUI

struct PaymentView: View {
    @EnvironmentObject var authModel: AuthModel

    @State private var name = ""
    @State private var cardNumber = ""
    @State private var expiry = ""
    @State private var cvv = ""
    @State private var amount = "100"

    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    private func validate() -> String? {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "Enter Name and Last Name" }
        if cardNumber.filter(\.isNumber).count < 12 { return "Card Number is too short" }
        if expiry.trimmingCharacters(in: .whitespacesAndNewlines).count < 4 { return "Enter expiration date (MM/YY)." }
        if cvv.filter(\.isNumber).count < 3 { return "CVV must be at least 3 nimbers." }
        if Int(amount) == nil { return "Amount must be a number" }
        return nil
    }

    var body: some View {
        Form {
            Section("Payment (mock)") {
                TextField("Name and Last name", text: $name)
                    .textInputAutocapitalization(.words)

                TextField("card number", text: $cardNumber)
                    .keyboardType(.numberPad)

                TextField("Expiration date (MM/YY)", text: $expiry)
                    .keyboardType(.numbersAndPunctuation)

                SecureField("CVV", text: $cvv)
                    .keyboardType(.numberPad)

                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }

            Section {
                Button {
                    Task { await submit() }
                } label: {
                    HStack {
                        Spacer()
                        if isLoading { ProgressView() } else { Text("Pay").fontWeight(.semibold) }
                        Spacer()
                    }
                }
                .disabled(isLoading)
            }

            Section("Testing") {
                Text("Jeśli numer karty kończy się na 0, serwer zwróci FAIL. Inaczej SUCCESS.")
                    .font(.footnote)
            }
        }
        .navigationTitle("Pyament")
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }

    @MainActor
    private func submit() async {
        if let err = validate() {
            alertTitle = "Forms ERROR"
            alertMessage = err
            showAlert = true
            return
        }

        isLoading = true
        defer { isLoading = false }

        let req = PaymentRequest(
            name: name,
            cardNumber: cardNumber,
            expiry: expiry,
            cvv: cvv,
            amount: Int(amount) ?? 0
        )

        do {
            let res = try await authModel.pay(request: req)
            if res.status == "success" {
                alertTitle = "Success"
            } else {
                alertTitle = "Ffail"
            }
            alertMessage = res.message + (res.paymentId != nil ? "\nID: \(res.paymentId!)" : "")
            showAlert = true
        } catch {
            alertTitle = "ERROR"
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
}
