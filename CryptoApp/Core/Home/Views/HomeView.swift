//
//  HomeView.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/20/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            // Background Layer
            Color.theme.background
                .ignoresSafeArea()
            
            // Content Layer
            // Header
            VStack {
                Text("Header")
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
}
