//
//  String.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 3/15/26.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
