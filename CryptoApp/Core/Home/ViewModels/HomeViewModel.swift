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
        // Updates allCoins
        $searchText
            .combineLatest(dataService.$allCoins)
            // add a delay for 0.5 seconds before execute a code below
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { (text, startingCoins) -> [Coin] in
                guard !text.isEmpty else { return startingCoins }
                
                let lowercasedText = text.lowercased()
                
                return startingCoins.filter { (coin) -> Bool in
                    return coin.name.contains(lowercasedText) ||
                    coin.symbol.contains(lowercasedText) ||
                    coin.id.contains(lowercasedText)
                }
            }
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellable)
    }
}
