//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/25/26.
//

import Foundation
import Combine

class MarketDataService {
    @Published var marketData: MarketData?
    var marketDataSubscription: AnyCancellable?
    
    private let urlString = "https://api.coingecko.com/api/v3/global"
    
    init() {
        getMarketData()
    }
    
    func getMarketData() {
        guard let url = URL(string: urlString) else {
            print("❌ ERROR: Invalid URL")
            return
        }
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}

