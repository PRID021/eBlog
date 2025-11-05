//
//  CollapsibleHeader.swift
//  eBlog
//
//  Created by mac on 5/11/25.
//

import SwiftUI

struct CollapsibleHeader: View {
    @ObservedObject var viewModel: PlayerViewModel
    var scrollOffset: CGFloat

    var body: some View {
        let maxHeight: CGFloat = 320
        let minHeight: CGFloat = 160
        let currentHeight = max(minHeight, maxHeight - scrollOffset)

        VStack(spacing: 8) {
            // MARK: - Audio Visualizer
//            AudioBarsView(viewModel: viewModel)
            WaveformView(viewModel: viewModel)
                .frame(height: 120)

            // MARK: - Controls
            if currentHeight > minHeight + 1 {
                VStack(spacing: 0) {
                    CustomSlider(
                        progress: Binding(
                            get: { viewModel.currentTime },
                            set: { viewModel.seek(to: $0) }
                        ),
                        range: 0...viewModel.duration
                    )
                    .padding(.horizontal, 16)

                    if let _ = viewModel.currentSong {
                        HStack {
                            Text(formatTime(viewModel.currentTime))
                                .font(.caption)
                                .foregroundColor(.gray)

                            Spacer()

                            Text(formatTime(viewModel.duration))
                                .font(.caption)
                                .foregroundColor(.gray)

                            Button(action: { viewModel.toggleRepeatMode() }) {
                                Image(systemName: viewModel.repeatMode == .repeatOne ? "repeat.1" : "repeat")
                                    .foregroundColor(viewModel.repeatMode == .none ? .gray : .blue)
                                    .font(.system(size: 14))
                            }
                            .padding(.horizontal, 8)
                        }
                        .padding(.top, 4)
                    }

                    // MARK: - Playback Controls
                    HStack(spacing: 50) {
                        Button(action: { viewModel.previous() }) {
                            Image(systemName: "backward.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }

                        Button(action: {
                            viewModel.isPlaying ? viewModel.pause() : viewModel.playOrResume()
                        }) {
                            Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                                .shadow(color: .white.opacity(0.15), radius: 10, y: 4)
                        }

                        Button(action: { viewModel.next() }) {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 8)
                }
                .transition(.opacity)
            }
        }
        .frame(height: currentHeight > minHeight + 1 ? currentHeight : 120)
        .padding(.horizontal)
        .background(Color(red: 0.10, green: 0.10, blue: 0.10)) // slightly lighter header background (#1A1A1A)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.3), radius: 10, y: 4)
    }

    private func formatTime(_ seconds: Double) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return String(format: "%02d:%02d", m, s)
    }
}
