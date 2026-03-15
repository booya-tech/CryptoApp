//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 3/15/26.
//

import SwiftUI

struct SettingsView: View {
    let defaultURL = URL(string: "https://www.google.com/")!
    let youtubeURL = URL(string: "https://www.youtube.com/@booyadev-d7q")!
    let githubURL = URL(string: "https://github.com/booya-tech")!
    let coingeckoURL = URL(string: "https://www.coingecko.com/")!
    
    var body: some View {
        NavigationStack {
            List {
                swiftfulThinkingSection
                
                coinGeckoSection
                
                developerSection
                
                applicationSection
            }
            .foregroundStyle(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}

extension SettingsView {
    private var swiftfulThinkingSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following a @SwiftfulThinking course on YouTube. It uses MVVM Architecture, Combine, and CoreData. Shout out to Nick Sarno!")
                    .foregroundStyle(Color.theme.secondaryText)
            }
            .padding(.vertical)
            Link("Subscribe on Youtube 📺", destination: youtubeURL)
        } header: {
            Text("Swiftful Thinking")
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko Prices may be slightly delayed.")
                    .foregroundStyle(Color.theme.secondaryText)
            }
            .padding(.vertical)
            Link("Visit CoinGecko 🦎", destination: coingeckoURL)
        } header: {
            Text("Coingecko")
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Boo Panachai. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, and data persistance.")
                    .foregroundStyle(Color.theme.secondaryText)
            }
            .padding(.vertical)
            Link("Visit my GitHub 💎", destination: githubURL)
        } header: {
            Text("Developer")
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var applicationSection: some View {
        Section {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        } header: {
            Text("Application")
                .foregroundStyle(Color.theme.accent)
        }
    }
}
