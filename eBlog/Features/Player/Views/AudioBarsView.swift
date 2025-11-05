//
//  AudioBarsView.swift
//  eBlog
//
//  Created by mac on 4/11/25.
//

import SwiftUI
import AVFoundation

import SwiftUI
import AVFoundation

struct AudioBarsView: View {
    @ObservedObject var viewModel: PlayerViewModel
    let barCount = 20        // Number of vertical bars
    let segmentCount = 8     // Number of stacked segments per bar

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(0..<barCount, id: \.self) { i in
                let normalized = CGFloat(viewModel.audioLevels[safe: i] ?? 0)
                VStack(spacing: 2) {
                    ForEach(0..<segmentCount, id: \.self) { j in
                        Rectangle()
                            .fill(gradientColor(for: j))
                            .frame(height: normalized * 100 / CGFloat(segmentCount))
                            .opacity(normalized * CGFloat(j + 1) / CGFloat(segmentCount))
                    }
                }
            }
        }
        .frame(height: 100)
        .padding(.horizontal)
        .onAppear { viewModel.startMetering() }
        .onDisappear { viewModel.stopMetering() }
    }

    private func gradientColor(for segment: Int) -> Color {
        // Gradient from cyan -> blue -> purple -> pink
        let t = Double(segment) / Double(segmentCount - 1)
        return Color(
            red: 0.5 + 0.5 * t,
            green: 0.0,
            blue: 1.0 - 0.5 * t
        )
    }
}





extension Float {
    // Convert -160 ... 0 dB to 0 ... 1
    func normalizedPower() -> Float {
        let minDb: Float = -60
        return max(0, (self - minDb) / -minDb)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
