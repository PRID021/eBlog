import SwiftUI
import AVFoundation

struct PlayerView: View {
    @StateObject private var viewModel: PlayerViewModel
    @State private var scrollOffset: CGFloat = 0

    init(track: Track) {
        _viewModel = StateObject(wrappedValue: PlayerViewModel(track: track))
    }

    var body: some View {
        VStack(spacing: 16) {
            CollapsibleHeader(viewModel: viewModel, scrollOffset: scrollOffset)
                .zIndex(1)

            SongListView(
                viewModel: viewModel,
                scrollOffset: $scrollOffset
            )
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(red: 0.07, green: 0.07, blue: 0.07).ignoresSafeArea())
    }
}

private struct SongListView: View {
    @ObservedObject var viewModel: PlayerViewModel
    @Binding var scrollOffset: CGFloat

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let track = viewModel.currentTrack {
                    ForEach(track.songs) { song in
                        SongRow(
                            song: song,
                            isPlaying: song == viewModel.currentSong,
                            onTap: { viewModel.play(song: song) }
                        )
                    }
                }
            }
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            scrollOffset = -proxy.frame(in: .named("scroll")).origin.y
                        }
                        .onChange(of: proxy.frame(in: .named("scroll")).origin.y) { newValue in
                            scrollOffset = -newValue
                        }
                }
            )
        }
        .coordinateSpace(name: "scroll")
    }
}

private struct SongRow: View {
    let song: Song
    let isPlaying: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            Text(song.title)
                .foregroundColor(isPlaying ? .white : .gray)
                .lineLimit(1)
            Spacer()
            if isPlaying {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)

        Divider()
            .background(Color.white.opacity(0.1))
    }
}
