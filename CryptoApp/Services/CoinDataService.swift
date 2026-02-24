//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/23/26.
//

import Foundation
import Combine

class CoinDataService {
    @Published var allCoins: [Coin] = []
    var coinSubscription: AnyCancellable?
    
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&price_change_percentage=24h&order=market_cap_desc&per_page=250&page=1&sparkline=true"
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: urlString) else {
            print("❌ ERROR: Invalid URL")
            return
        }
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
    }
}
