import SwiftUI

struct TrackDetailView: View {
    var track: Track
    @ObservedObject var library: LibraryViewModel
    @EnvironmentObject var coordinator: AppCoordinatorImpl
    @State private var showImporter = false
    @State private var showRenameAlert = false
    @State private var newTrackName = ""

    var body: some View {
        VStack {
            // MARK: - Play Track Button
            Button(action: {
                coordinator.push(.player(track: track))
            }) {
                HStack {
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                    Text("Play Track")
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.top)

            List {
                Section(header: Text("Songs")) {
                    ForEach(track.songs) { song in
                        Text(song.title)
                    }
                }
            }

            HStack(spacing: 16) {
                Button("Import Song") {
                    showImporter = true
                }
                .buttonStyle(.borderedProminent)

                Button("Rename Track") {
                    newTrackName = track.name
                    showRenameAlert = true
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationTitle(track.name)
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                for url in urls {
                    library.importSong(from: url, to: track)
                }
            case .failure(let error):
                print("Failed to import: \(error.localizedDescription)")
            }
        }
        .alert("Rename Track", isPresented: $showRenameAlert) {
            TextField("New name", text: $newTrackName)
            Button("Save") {
                library.rename(track: track, to: newTrackName)
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
