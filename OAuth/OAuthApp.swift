//
//  OAuthApp.swift
//  OAuth
//
//  Created by user277759 on 12/30/25.
//

import SwiftUI
import GoogleSignIn
import FBSDKCoreKit

@main
struct OAuthApp: App {
    @StateObject var authModel = AuthModel()

    var body: some Scene {
        WindowGroup {
            AppView()
                .onAppear {
                    ApplicationDelegate.shared.application(
                        UIApplication.shared,
                        didFinishLaunchingWithOptions: nil
                    )
                }
                .environmentObject(authModel)
                .onOpenURL { url in
                    if url.scheme == "oauth-swift" {
                        GIDSignIn.sharedInstance.handle(url)
                    } else {
                        _ = ApplicationDelegate.shared.application(
                            UIApplication.shared,
                            open: url,
                            sourceApplication: nil,
                            annotation: UIApplication.OpenURLOptionsKey.annotation
                        )
                    }
                }
        }
    }
}
