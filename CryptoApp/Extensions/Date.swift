//
//  Date.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 3/10/26.
//

import Foundation

extension Date {
    // 2024-04-07T15:24:51.021Z
    init(coinGeckoString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinGeckoString) ?? Date()
        
        self.init(timeInterval: 0, since: date)
    }
}
