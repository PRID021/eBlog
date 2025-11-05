//
//  CollapsibleHeader.swift
//  eBlog
//
//  Created by mac on 5/11/25.
//

import SwiftUI

struct CollapsibleHeader: View {
    @ObservedObject var viewModel: PlayerViewModel

    var body: some View {
        VStack {
            Spacer()
            
            CustomSlider(
                progress: Binding(
                    get: { viewModel.currentTime },
                    set: { viewModel.seek(to: $0) }
                ),
                range: 0...viewModel.duration
            ).padding(.horizontal,24)
            
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
               
            }
            .padding(.horizontal,24)
            
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
            
            Spacer()
        }
        .safeAreaPadding(.bottom)
        .background(Color(red: 0.10, green: 0.10, blue: 0.10))
        .cornerRadius(20)
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return String(format: "%02d:%02d", m, s)
    }
}
