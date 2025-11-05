import SwiftUI
import AVFoundation

@MainActor
class LibraryViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    
    init() {
        loadLibrary()
    }

    // MARK: - Track Management
    func createTrack(named name: String) {
        let newTrack = Track(name: name)
        tracks.append(newTrack)
        saveLibrary()
    }
    
    func rename(track: Track, to newName: String) {
        guard let index = tracks.firstIndex(where: { $0.id == track.id }) else { return }
        tracks[index].name = newName
        saveLibrary()
    }

    func delete(track: Track) {
        tracks.removeAll { $0.id == track.id }
        saveLibrary()
    }

    func addSong(_ song: Song, to track: Track) {
        guard let index = tracks.firstIndex(where: { $0.id == track.id }) else { return }
        tracks[index].songs.append(song)
        saveLibrary()
    }

    // MARK: - File Import
    func importSong(from url: URL, to track: Track) {
        guard url.startAccessingSecurityScopedResource() else {
            print("❌ No permission for file: \(url.lastPathComponent)")
            return
        }
        defer { url.stopAccessingSecurityScopedResource() }

        let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(url.lastPathComponent)

        do {
            // Replace if already exists
            if FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.removeItem(at: destination)
            }
            try FileManager.default.copyItem(at: url, to: destination)

            // Get metadata
            let asset = AVAsset(url: destination)
            let duration = CMTimeGetSeconds(asset.duration)
            let title = url.deletingPathExtension().lastPathComponent

            let song = Song(title: title, fileURL: destination, duration: duration)
            addSong(song, to: track)
            
            print("✅ Imported: \(title)")
        } catch {
            print("❌ Import failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Persistence
    func saveLibrary() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(tracks) {
            UserDefaults.standard.set(data, forKey: "libraryData")
        }
    }

    func loadLibrary() {
        if let data = UserDefaults.standard.data(forKey: "libraryData"),
           let saved = try? JSONDecoder().decode([Track].self, from: data) {
            tracks = saved
        }
    }
}
