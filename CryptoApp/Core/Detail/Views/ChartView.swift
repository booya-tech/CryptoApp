//
//  ChartView.swift
//  CryptoApp
//
//  Created by Panachai Sulsaksakul on 3/10/26.
//

import SwiftUI

struct ChartView: View {
    let data: [Double]
    let maxY: Double
    let minY: Double
    
    init(coin: Coin) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
    }
    
    /// Math
    /// 60,000 - max
    /// 50,000 - min
    /// 60,000 - 50,000 = 10,000 - yAxis
    /// 52,000 - data point
    /// 52,000 - 50,000 - 2,000 / 10,000 = 20%
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yAxis))
                    }
                    
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}

#Preview {
    ChartView(coin: DeveloperPreview.dev.coin)
}
