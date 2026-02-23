//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/19/26.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
        }
        .environmentObject(vm)
    }
}
