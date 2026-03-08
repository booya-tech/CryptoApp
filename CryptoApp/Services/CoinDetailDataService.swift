//
//  CoinDetailDataService.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 3/4/26.
//

import Foundation
import Combine

class CoinDetailDataService {
    @Published var coinDetails: CoinDetailModel? = nil
    var coinDetailSubscription: AnyCancellable?
    let coin: Coin
    
    private var urlString = ""
    
    init(coin: Coin) {
        self.coin = coin
        urlString = "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        
        getCoinDetail()
    }
    
    func getCoinDetail() {
        guard let url = URL(string: urlString) else {
            print("❌ ERROR: Invalid URL")
            return
        }
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.coinDetails = returnedCoins
                self?.coinDetailSubscription?.cancel()
            })
    }
}


