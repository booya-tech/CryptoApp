//
//  CoinImageService.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/24/26.
//

import Foundation
import Combine
import SwiftUI

class CoinImageService {
    @Published var image: UIImage? = nil
    
    private var coinImageSubscription: AnyCancellable?
    private var coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        guard let url = URL(string: coin.image) else {
            print("❌ ERROR: Invalid URL")
            return
        }
        
        coinImageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoinImage) in
                self?.image = returnedCoinImage
                self?.coinImageSubscription?.cancel()
            })
    }
}
