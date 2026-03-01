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
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var statistics: [Statistic] = [
        Statistic(title: "Title", value: "Value", percentageChange: 1),
        Statistic(title: "Title", value: "Value"),
        Statistic(title: "Title", value: "Value"),
        Statistic(title: "Title", value: "Value", percentageChange: -7),
    ]
    @Published var sortOption: SortOption = .holdings
    
    //MARK: - Service
    private var coinDataService = CoinDataService()
    private var marketDataService = MarketDataService()
    private var portfolioDataService = PortfolioDataService()
    private var cancellable = Set<AnyCancellable>()
    
    enum SortOption {
        case rank
        case rankReversed
        case holdings
        case holdingsReversed
        case price
        case priceReversed
    }
    
    init() {
        addSubscribers()
    }
    //MARK: - Public method
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
    }
    
    //MARK: - Private method
    private func addSubscribers() {
        // Updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            // add a delay for 0.5 seconds before execute a code below
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellable)
        
        // Update portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                
                self.portfolioCoins = self.filterPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellable)
        
        // Update statistics
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarket)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellable)
    }
    
    private func filterAndSortCoins(text: String, coins: [Coin], sort: SortOption) -> [Coin] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        
        return updatedCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [Coin]) {
        switch sortOption {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        }
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else { return coins }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.contains(lowercasedText) ||
            coin.symbol.contains(lowercasedText) ||
            coin.id.contains(lowercasedText)
        }
    }
    
    private func filterPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [Coin], portfolioCoins: [PortfolioEntity]) -> [Coin] {
        allCoins
        /// return Coin? as optional to allow return nil
            .compactMap { (coin) -> Coin? in
                guard let entity = portfolioCoins.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarket(marketData: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data = marketData else {
            return stats
        }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketData, percentageChange: data.marketCapChangePercentage24hUsd)
        let volumn = Statistic(title: "24h Volume", value: data.volumn)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue =
        portfolioCoins
            .map( { $0.currentHoldingsValue })
            .reduce(0, +)
        
        let previousValue =
            portfolioCoins
                .map { (coin) -> Double in
                    let currentValue = coin.currentHoldingsValue
                    let percentChange = coin.priceChangePercentage24H ?? 0 / 100 // 50 / 100 = 0.5
                    let previousValue = currentValue / (1 + percentChange)
                    
                    return previousValue
                }
                .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = Statistic(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange
        )
        
        stats.append(contentsOf: [
            marketCap,
            volumn,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
}
