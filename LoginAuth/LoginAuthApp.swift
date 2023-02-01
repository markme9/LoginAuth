//
//  LoginAuthApp.swift
//  LoginAuth
//
//  Created by Mark on 2/1/23.
//

import SwiftUI
import FirebaseCore

@main
struct LoginAuthApp: App {
    @StateObject var user = User()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
        }
    }
}
