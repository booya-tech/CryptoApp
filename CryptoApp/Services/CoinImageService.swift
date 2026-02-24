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
    private let fileManager = LocalFileManager.instance
    private let imageName: String
    private let folderName: String = "coin_images"
    
    init(coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            self.image = savedImage
        } else {
            fetchCoinImage()
        }
    }
    
    private func fetchCoinImage() {
        guard let url = URL(string: coin.image) else {
            print("❌ ERROR: Invalid URL")
            return
        }
        
        coinImageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoinImage) in
                guard let self = self, let downloadedImage = returnedCoinImage else { return }
                self.image = downloadedImage
                self.coinImageSubscription?.cancel()
                self.fileManager.saveImage(
                    image: downloadedImage,
                    imageName: imageName,
                    folderName: folderName
                )
            })
    }
}
