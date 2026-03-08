//
//  DetailView.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 3/1/26.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    @StateObject private var vm: DetailViewModel
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Initializing Detail View for \(coin.name)")
    }
    
    var body: some View {
        Text("Hello")
    }
}

#Preview {
    DetailView(coin: DeveloperPreview.dev.coin)
}
