import SwiftUI

struct UserView: View {
    @EnvironmentObject var authModel: AuthModel

    var body: some View {
        NavigationStack {
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

                    Section("Payments") {
                        NavigationLink {
                            PaymentView()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "creditcard")
                                    .imageScale(.small)
                                    .font(.title2)
                                Text("Mock Payment")
                            }
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
                .navigationTitle("User")
            }
        }
    }
}
