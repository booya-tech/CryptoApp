//
//  CircleButtonView.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/20/26.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    
    var body: some View {
        // Icon
        Image(systemName: iconName)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background {
                Circle()
                    .foregroundStyle(Color.theme.background)
            }
            .shadow(
                color: Color.theme.accent.opacity(0.3),
                radius: 6
            )
            .padding()
    }
}

// Light Mode
#Preview(traits: .sizeThatFitsLayout) {
    Group {
        CircleButtonView(iconName: "info")
    }
}

// Dark Mode
#Preview(traits: .sizeThatFitsLayout) {
    Group {
        CircleButtonView(iconName: "heart.fill")
            .preferredColorScheme(.dark)
    }
}
