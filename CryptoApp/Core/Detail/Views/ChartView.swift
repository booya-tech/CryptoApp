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
    let lineColor: Color
    
    init(coin: Coin) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
    }
    
    /// Math
    /// 60,000 - max
    /// 50,000 - min
    /// 60,000 - 50,000 = 10,000 - yAxis
    /// 52,000 - data point
    /// 52,000 - 50,000 - 2,000 / 10,000 = 20%
    var body: some View {
        chartView
            .frame(height: 200)
            .background {
                chartBackground
            }
            .overlay(alignment: .leading) {
                VStack {
                    Text(maxY.formattedWithAbbreviations())
                    Spacer()
                    let median  = ((maxY + minY) / 2).formattedWithAbbreviations()
                    Text(median)
                    Spacer()
                    Text(minY.formattedWithAbbreviations())
                }
            }
    }
}

#Preview {
    ChartView(coin: DeveloperPreview.dev.coin)
}

extension ChartView {
    private var chartView: some View {
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
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
}
