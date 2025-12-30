//
//  User.swift
//  OAuth
//
//  Created by user277759 on 12/30/25.
//

import Foundation

struct User: Codable, Equatable {
    let firstName: String
    let lastName: String
    let username: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: "\(firstName) \(lastName)"){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}
