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
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "Enter name and last name." }
        if cardNumber.filter(\.isNumber).count < 12 { return "Card number is too short." }
        if expiry.trimmingCharacters(in: .whitespacesAndNewlines).count < 4 { return "Enter expiration date (MM/YY)." }
        if cvv.filter(\.isNumber).count < 3 { return "CVV must be at least 3 numbers." }
        if Int(amount) == nil { return "Amount must be a number." }
        return nil
    }

    var body: some View {
        Form {
            Section("Payment (mock)") {
                TextField("Name and last name", text: $name)
                    .textInputAutocapitalization(.words)
                    .accessibilityIdentifier("pay.name")

                TextField("Card number", text: $cardNumber)
                    .keyboardType(.numberPad)
                    .accessibilityIdentifier("pay.card")

                TextField("Expiration date (MM/YY)", text: $expiry)
                    .keyboardType(.numbersAndPunctuation)
                    .accessibilityIdentifier("pay.expiry")

                SecureField("CVV", text: $cvv)
                    .keyboardType(.numberPad)
                    .accessibilityIdentifier("pay.cvv")

                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
                    .accessibilityIdentifier("pay.amount")
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
                .accessibilityIdentifier("pay.submit")
            }

            Section("Testing") {
                Text("Jeśli numer karty kończy się na 0, serwer zwróci FAIL. Inaczej SUCCESS.")
                    .font(.footnote)
            }
        }
        .navigationTitle("Payment")
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }

    @MainActor
    private func submit() async {
        if let err = validate() {
            alertTitle = "Form error"
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
            alertTitle = (res.status == "success") ? "Success" : "Failed"
            alertMessage = res.message + (res.paymentId != nil ? "\nID: \(res.paymentId!)" : "")
            showAlert = true
        } catch {
            alertTitle = "Error"
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
}

