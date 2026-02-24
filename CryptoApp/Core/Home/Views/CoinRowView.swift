//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/21/26.
//

import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showHoldingsColumn {
                centerColumn
            }
            
            rightColumn
        }
        .font(.subheadline)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CoinRowView(
        coin: DeveloperPreview.dev.coin,
        showHoldingsColumn: true
    )
}

#Preview(traits: .sizeThatFitsLayout) {
    CoinRowView(
        coin: DeveloperPreview.dev.coin,
        showHoldingsColumn: true
    )
    .preferredColorScheme(.dark)
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack(spacing: 0) {
            // Currency Rank
            Text("\(coin.rank)")
                .frame(minWidth: 30)
                .font(.caption)
            // Currency Image
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            
            // Currency Name
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        // Current Price & Price changes in 24hrs
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundStyle(
                    (coin.priceChangePercentage24H ?? 0 >= 0) ? Color.theme.green : Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
