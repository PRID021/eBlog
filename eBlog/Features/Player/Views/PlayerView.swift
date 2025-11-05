import SwiftUI
import AVFoundation

struct PlayerView: View {
    @StateObject private var viewModel: PlayerViewModel

    init(track: Track) {
        _viewModel = StateObject(wrappedValue: PlayerViewModel(track: track))
    }

    var body: some View {
        VStack {
            WaveformView(viewModel: viewModel)
                .frame(height: 120)
            Spacer()
            SongListView(viewModel: viewModel)
            .background(Color(red: 0.07, green: 0.07, blue: 0.07).ignoresSafeArea())
            .onDisappear {
                viewModel.stop()
                viewModel.stopMetering()
                viewModel.stopMonitoringAudio()
            }
            
            Spacer()
            CollapsibleHeader(viewModel: viewModel)
                .frame(height: 200)
     
        }

        .edgesIgnoringSafeArea(.bottom)
        .background(Color(red: 0.10, green: 0.10, blue: 0.10))
        .navigationBarBackButtonHidden(true)
        
    }
   
   
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

private struct SongListView: View {
    @ObservedObject var viewModel: PlayerViewModel

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




