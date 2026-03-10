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
    @Published var overviewStatistics: [Statistic] = []
    @Published var addiotionalStatistics: [Statistic] = []
    @Published var coin: Coin
    
    //MARK: - Service
    private let coinDetailDataService: CoinDetailDataService
    
    //MARK: - Combine
    private var cancellable = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        coinDetailDataService = CoinDetailDataService(coin: coin)
        
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailDataService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.addiotionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellable)
    }
    
    private func mapDataToStatistics(coinDetail: CoinDetailModel?, coin: Coin) -> (overview: [Statistic], additional: [Statistic]) {
        let overviewArray = createOverviewArray(coin: coin)
        let additionalArray = createAdditionalArray(coinDetail: coinDetail, coin: coin)
        
        
        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(coin: Coin) -> [Statistic] {
        // overview
        let price = self.coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = self.coin.priceChangePercentage24H
        let priceStat = Statistic(
            title: "Current Price",
            value: price,
            percentageChange: pricePercentChange
        )
        
        let marketCap = "$" + (self.coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = self.coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(
            title: "Market Capitalization",
            value: marketCap,
            percentageChange: marketCapPercentChange
        )
        
        let rank = "\(self.coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volumn = "$" + (self.coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumnStat = Statistic(
            title: "Volume",
            value: volumn
        )
        
        let overviewArray: [Statistic] = [
            priceStat,
            marketCapStat,
            rankStat,
            volumnStat
        ]
        
        return overviewArray
    }
    
    private func createAdditionalArray(coinDetail: CoinDetailModel?, coin: Coin) -> [Statistic] {
        // additional
        let high = self.coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = Statistic(
            title: "24h High",
            value: high
        )
        
        let low = self.coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = Statistic(
            title: "24h Low",
            value: low
        )
        
        let priceChange = self.coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange2 = self.coin.priceChangePercentage24H
        let priceChangeStat = Statistic(
            title: "24h Price Change",
            value: priceChange,
            percentageChange: pricePercentChange2
        )
        
        let marketCapChange = "$" + (self.coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2 = self.coin.marketCapChangePercentage24H
        let marketCapChangeStat = Statistic(
            title: "24h Market Cap Change",
            value: marketCapChange,
            percentageChange: marketCapPercentChange2
        )
        
        let additionalArray: [Statistic] = [
            highStat,
            lowStat,
            priceChangeStat,
            marketCapChangeStat
        ]
        
        return additionalArray
    }
}
