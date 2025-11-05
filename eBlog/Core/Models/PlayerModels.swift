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


