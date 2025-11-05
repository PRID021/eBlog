//
//  WaveformView.swift
//  eBlog
//
//  Created by mac on 5/11/25.
//

import SwiftUI
import AVFoundation
import Accelerate
//
//  WaveformView.swift
//  eBlog
//
//  Created by mac on 5/11/25.
//

import SwiftUI

struct WaveformView: View {
    @ObservedObject var viewModel: PlayerViewModel
    @State private var samples: [Float] = Array(repeating: 0.0, count: 100)

    var body: some View {
        Canvas { ctx, size in
            let (wavePath, closedPath) = waveformPaths(size: size)

            // Shared gradient (same for fill AND stroke)
            let gradient = Gradient(colors: [
                Color.blue.opacity(0.8),
                Color.purple.opacity(0.8),
                Color.pink.opacity(0.8)
            ])

            let gradientShader = GraphicsContext.Shading.linearGradient(
                gradient,
                startPoint: CGPoint(x: 0, y: size.height),
                endPoint: CGPoint(x: size.width, y: 0)
            )

            // 1. Fill the area under the curve
            ctx.fill(closedPath, with: gradientShader)

            // 2. Stroke the curve with the SAME gradient
            ctx.stroke(
                wavePath,
                with: gradientShader,
                lineWidth: 3
            )

            // 3. Optional: subtle baseline (now invisible or very faint)
            let midY = size.height / 2
            let baseline = Path { p in
                p.move(to: CGPoint(x: 0, y: midY))
                p.addLine(to: CGPoint(x: size.width, y: midY))
            }
            ctx.stroke(baseline, with: .color(.white.opacity(0)), lineWidth: 0.5)
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .clipped()
        .onReceive(viewModel.$waveformSamples){ newWaves in
            self.samples = newWaves
        }
        .onAppear {
            viewModel.startMonitoringAudio()
        }
        .onDisappear {
            viewModel.stopMonitoringAudio()
        }
    }

    private func waveformPaths(size: CGSize) -> (Path, Path) {
        var wave = Path()
        var closed = Path()

        let midY = size.height / 2
        let step = size.width / CGFloat(samples.count - 1)

        wave.move(to: CGPoint(x: 0, y: midY))
        closed.move(to: CGPoint(x: 0, y: size.height))
        closed.addLine(to: CGPoint(x: 0, y: midY))

        for (i, sample) in samples.enumerated() {
            let x = CGFloat(i) * step
            let y = midY - CGFloat(sample) * midY * 0.9  // slightly less tall for beauty

            wave.addLine(to: CGPoint(x: x, y: y))
            closed.addLine(to: CGPoint(x: x, y: y))
        }

        closed.addLine(to: CGPoint(x: size.width, y: midY))
        closed.addLine(to: CGPoint(x: size.width, y: size.height))
        closed.closeSubpath()

        return (wave, closed)
    }
}
