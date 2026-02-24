//
//  CoinImageViewModel.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/24/26.
//

import Foundation
import Combine
import SwiftUI

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private var coin: Coin
    private var dataService: CoinImageService
    private var cancellable = Set<AnyCancellable>()


    init(coin: Coin) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.addSubscription()
        self.isLoading = true
    }
    
    private func addSubscription() {
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedCoinImage) in
                self?.image = returnedCoinImage
            }
            .store(in: &cancellable)
    }
}
