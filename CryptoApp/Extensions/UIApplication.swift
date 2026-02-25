//
//  UIApplication.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/24/26.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
