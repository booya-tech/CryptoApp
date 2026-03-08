//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 3/4/26.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    //MARK: - Publisher
    //    @Published var coinDetails: CoinDetailModel?
    
    //MARK: - Service
    private let coinDetailDataService: CoinDetailDataService
    
    private var cancellable = Set<AnyCancellable>()
    
    init(coin: Coin) {
        coinDetailDataService = CoinDetailDataService(coin: coin)
        
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailDataService.$coinDetails
            .sink { returnedCoinDetails in
                print("Received coin details data from network. \(String(describing: returnedCoinDetails))")
            }
            .store(in: &cancellable)
    }
}
