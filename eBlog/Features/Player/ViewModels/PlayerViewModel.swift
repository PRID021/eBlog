import AVFoundation
import Combine
import SwiftUI
import MediaPlayer

// MARK: - PlayerViewModel
@MainActor
class PlayerViewModel: NSObject, ObservableObject {
    // MARK: - Published
    @Published var currentSong: Song?
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var audioLevels: [Float] = []
    @Published var repeatMode: RepeatMode = .none
    @Published var currentTrack: Track? {
        didSet {
            guard let track = currentTrack else { return }
            trackSongs = SongPlayCounter.shared.sortSongsByCount(track.songs)
        }
    }

    // MARK: - Private properties
    private var trackSongs: [Song] = []
    private var currentIndex: Int = 0
    private var player: AVAudioPlayer?
    private var timer: Timer?
    private var meteringTimer: Timer?
    private var hasCountedPlay = false

    // MARK: - Init
    init(track: Track) {
        super.init()
        configureAudioSession()
        setupRemoteCommandCenter()

        let sortedSongs = SongPlayCounter.shared.sortSongsByCount(track.songs)
        self.currentTrack = Track(name: track.name, songs: sortedSongs)
        self.trackSongs = sortedSongs
        self.currentIndex = 0

        if let firstSong = sortedSongs.first {
            play(song: firstSong)
        }
    }
}


// MARK: - Playback
extension PlayerViewModel: AVAudioPlayerDelegate {
    func play(song: Song) {
        stop()
        stopMetering()
        hasCountedPlay = false
        print("[Player] ▶️ \(song.title)")

        guard FileManager.default.fileExists(atPath: song.fileURL.path) else {
            print("[Player] ❌ Missing file: \(song.fileURL.path)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: song.fileURL)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()

            currentSong = song
            isPlaying = true
            duration = player?.duration ?? 0
            currentTime = 0

            startProgressTimer()
            startMetering()
            updateNowPlayingInfo()
        } catch {
            print("[Player] ⚠️ Failed to play \(song.title): \(error.localizedDescription)")
        }
    }

    func playOrResume() {
        guard let player = player, !player.isPlaying else { return }
        player.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func stop() {
        player?.stop()
        isPlaying = false
        currentSong = nil
        timer?.invalidate()
        timer = nil
        currentTime = 0
    }

    func seek(to time: Double) {
        player?.currentTime = time
        currentTime = time
    }

    // MARK: - Navigation
    func next() {
        guard currentIndex + 1 < trackSongs.count else { return }
        currentIndex += 1
        play(song: trackSongs[currentIndex])
    }

    func previous() {
        if currentTime > 2 {
            player?.currentTime = 0
            currentTime = 0
        } else if currentIndex > 0 {
            currentIndex -= 1
            play(song: trackSongs[currentIndex])
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard let song = currentSong else { return }

        switch repeatMode {
        case .none:
            if currentIndex + 1 < trackSongs.count {
                next()
            } else {
                stop()
            }
        case .repeatOne:
            play(song: song)
        case .repeatAll:
            if currentIndex + 1 < trackSongs.count {
                next()
            } else {
                currentIndex = 0
                play(song: trackSongs[currentIndex])
            }
        }

        updateNowPlayingInfo()
    }
}


// MARK: - Timers
extension PlayerViewModel {
    private func startProgressTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self, self.isPlaying else { return }
            self.currentTime = self.player?.currentTime ?? 0

            // ✅ Count play after 50%
            if let duration = self.player?.duration, duration > 0 {
                let progress = self.currentTime / duration
                if progress >= 0.5, !self.hasCountedPlay, let song = self.currentSong {
                    SongPlayCounter.shared.increment(for: song)
                    self.hasCountedPlay = true
                }
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
}



// MARK: - Metering
extension PlayerViewModel {
    func startMetering() {
        guard let player = player else { return }
        player.isMeteringEnabled = true
        audioLevels = Array(repeating: 0, count: 20)

        meteringTimer?.invalidate()
        meteringTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            player.updateMeters()
            DispatchQueue.main.async {
                self.audioLevels = (0..<20).map { _ in
                    player.averagePower(forChannel: 0).normalizedPower()
                }
            }
        }
        RunLoop.current.add(meteringTimer!, forMode: .common)
    }

    func stopMetering() {
        meteringTimer?.invalidate()
        meteringTimer = nil
    }
    
    func startMonitoringAudio(update: @escaping ([Float]) -> Void) {
        guard let player = player else { return }
        player.isMeteringEnabled = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            player.updateMeters()
            let power = player.averagePower(forChannel: 0)
            let normalized = pow(10, power / 20)
            
            // Generate smooth waveform samples
            let samples = (0..<100).map { i -> Float in
                let phase = Float(i) / 10.0
                return normalized * sin(phase)
            }
            
            update(samples)
        }
    }
    
    func stopMonitoringAudio() {
        timer?.invalidate()
        timer = nil
    }
    
}


// MARK: - Audio Session & Remote Commands
extension PlayerViewModel {
    func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("[AudioSession] Error: \(error.localizedDescription)")
        }
    }

    func setupRemoteCommandCenter() {
        let c = MPRemoteCommandCenter.shared()
        c.playCommand.addTarget { [weak self] _ in self?.playOrResume(); return .success }
        c.pauseCommand.addTarget { [weak self] _ in self?.pause(); return .success }
        c.nextTrackCommand.addTarget { [weak self] _ in self?.next(); return .success }
        c.previousTrackCommand.addTarget { [weak self] _ in self?.previous(); return .success }
    }
}


// MARK: - Now Playing Info
extension PlayerViewModel {
    func updateNowPlayingInfo() {
        guard let song = currentSong else { return }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: song.title,
            MPMediaItemPropertyArtist: song.artist ?? "",
            MPNowPlayingInfoPropertyElapsedPlaybackTime: player?.currentTime ?? 0,
            MPMediaItemPropertyPlaybackDuration: player?.duration ?? 0,
            MPNowPlayingInfoPropertyPlaybackRate: player?.isPlaying ?? false ? 1.0 : 0.0
        ]
    }

    func toggleRepeatMode() {
        switch repeatMode {
        case .none: repeatMode = .repeatAll
        case .repeatAll: repeatMode = .repeatOne
        case .repeatOne: repeatMode = .none
        }
    }
}
