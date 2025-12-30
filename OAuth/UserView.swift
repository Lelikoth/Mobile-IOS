//
//  UserView.swift
//  OAuth
//
//  Created by user277759 on 12/30/25.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var authModel: AuthModel

    var body: some View {
        if let user = authModel.user {
            List {
                Section("Profile") {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.gray)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(user.firstName) \(user.lastName)")
                                .fontWeight(.semibold)
                            Text(user.username)
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading, 10)
                    }
                }

                Section("Account") {
                    Button(role: .destructive) {
                        authModel.signOut()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.left.circle")
                                .imageScale(.small)
                                .font(.title2)
                            Text("Sign Out")
                        }
                    }
                }
            }
        }
    }
}
