//
//  PaymentModel.swift
//  OAuth
//
//  Created by user277759 on 1/25/26.
//

import Foundation

struct PaymentRequest: Codable {
    let name: String
    let cardNumber: String
    let expiry: String
    let cvv: String
    let amount: Int
}

struct PaymentResponse: Codable {
    let status: String      // "success" / "failed"
    let message: String
    let paymentId: String?
}
