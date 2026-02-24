//
//  CircleButtonAnimationView.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 2/20/26.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 3.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 0.5)
            .animation(.easeOut, value: animate)
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false))
}
