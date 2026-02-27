//
//  XMarkButton.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/27/26.
//

import SwiftUI

struct XMarkButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "xmark")
        })
    }
}

#Preview {
    XMarkButton()
}
