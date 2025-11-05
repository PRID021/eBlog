import Foundation
import AVFoundation

struct Song: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let title: String
    let fileURL: URL
    let duration: Double
    let artist: String?
    var playCount: Int = 0
    var lastPlayedDate: Date? = nil
    

    init(title: String, fileURL: URL, duration: Double = 0) {
        self.id = UUID()
        self.title = title
        self.fileURL = fileURL
        self.duration = duration
        self.artist = "Unknown"
    }
}

struct Track: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var songs: [Song]

    init(name: String, songs: [Song] = []) {
        self.id = UUID()
        self.name = name
        self.songs = songs
    }
}




// MARK: - RepeatMode
enum RepeatMode {
    case none
    case repeatOne
    case repeatAll
}

// MARK: - SongPlayCounter
final class SongPlayCounter {
    static let shared = SongPlayCounter()
    private var playCounts: [String: Int] = [:]
    private init() {}

    func increment(for song: Song) {
        let id = song.id.uuidString
        playCounts[id, default: 0] += 1
        print("[PlayCounter] \(song.title) played \(playCounts[id] ?? 0)x")
    }

    func count(for song: Song) -> Int {
        playCounts[song.id.uuidString, default: 0]
    }

    func sortSongsByCount(_ songs: [Song]) -> [Song] {
        songs.sorted { count(for: $0) > count(for: $1) }
    }
}

