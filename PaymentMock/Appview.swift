//
//  Appview.swift
//  OAuth
//
//  Created by user277759 on 12/30/25.
//

import SwiftUI

struct Appview: View {
    
    @EnvironmentObject var authModel: AuthModel
    
    var body: some View {
        Group {
            if authModel.user != nil {
                UserView()
            } else {
                LoginView()
            }
        }
    }
}
