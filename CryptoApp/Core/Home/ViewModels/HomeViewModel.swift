//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/22/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    
    //MARK: - Service
    private var dataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.$allCoins
            .sink { (returnedCoins) in
                self.allCoins = returnedCoins
            }
            .store(in: &cancellable)
    }
}
