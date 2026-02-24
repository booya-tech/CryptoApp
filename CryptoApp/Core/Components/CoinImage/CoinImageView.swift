//
//  CoinImageView.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/24/26.
//

import SwiftUI

struct CoinImageView: View {
    @StateObject private var vm: CoinImageViewModel
    
    init(coin: Coin) {
        /// to reference @StateObject private var vm add "_" at first.
        _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        // 3 Stages -> Display Image, Loading, Empty
        if let image = vm.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else if vm.isLoading {
            ProgressView()
        } else {
            Image(systemName: "questionmark")
                .foregroundStyle(Color.theme.secondaryText)
        }
    }
}

#Preview {
    CoinImageView(coin: DeveloperPreview.dev.coin)
}
