import SwiftUI
import AVFoundation

struct AudioBarsView: View {
    @ObservedObject var viewModel: PlayerViewModel
    let barCount = 20
    let barMaxHeight: CGFloat = 120

    // Small random factor per bar for independent growth
    var randomOffsets: [CGFloat] = (0..<20).map { _ in CGFloat.random(in: 0.7...1.0) }

    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(0..<barCount, id: \.self) { i in
                let level = CGFloat(viewModel.audioLevels[safe: i] ?? 0)
                let offset = randomOffsets[i % randomOffsets.count]
                let barHeight = max(level * barMaxHeight * offset, 2)
                
                Rectangle()
                    .fill(colorForBar(index: i, total: barCount))
                    .frame(
                        width: UIScreen.main.bounds.width / CGFloat(barCount) - 2,
                        height: barHeight
                    )
                    .cornerRadius(2)
                    .animation(.linear(duration: 0.05), value: viewModel.audioLevels)
            }
        }
        .frame(height: barMaxHeight, alignment: .bottom)
        .onAppear { viewModel.startMetering() }
        .onDisappear { viewModel.stopMetering() }
    }
    
    // Generate a rainbow-like gradient per bar
    private func colorForBar(index: Int, total: Int) -> LinearGradient {
        let hue = Double(index) / Double(total) // 0 ... 1
        return LinearGradient(
            gradient: Gradient(colors: [
                Color(hue: hue, saturation: 0.9, brightness: 0.9),
                Color(hue: hue, saturation: 0.7, brightness: 1.0)
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
    }
}

extension Float {
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
