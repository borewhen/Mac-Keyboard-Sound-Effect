import AVFoundation
import Foundation

class SoundPlayer: NSObject, AVAudioPlayerDelegate {
    private var soundData: Data?
    private var activePlayers: [AVAudioPlayer] = []
    private let activePlayersQueue = DispatchQueue(label: "SoundPlayer.activePlayersQueue")

    override init() {
        super.init()
        loadSoundbite()
    }

    private func loadSoundbite() {
        // Try to load from app bundle Resources first, then fall back to Bundle.module
        var soundURL: URL?
        
        if let bundleURL = Bundle.main.url(forResource: "soundbite", withExtension: "wav") {
            soundURL = bundleURL
        }
        
        if soundURL == nil, let moduleURL = Bundle.main.url(forResource: "soundbite", withExtension: "wav") {
            soundURL = moduleURL
        }
        
        guard let url = soundURL else {
            return
        }
        
        do {
            soundData = try Data(contentsOf: url)
        } catch {
            soundData = nil
        }
    }

    func playKeySound() {
        guard let data = soundData else { 
            print("No sound data available")
            return 
        }
        do {
            let player = try AVAudioPlayer(data: data)
            player.delegate = self
            player.prepareToPlay()
            activePlayersQueue.sync {
                activePlayers.append(player)
            }
            let success = player.play()
            if !success {
                print("Failed to start audio playback")
            }
        } catch {
            print("Error creating audio player: \(error)")
        }
    }

    // AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        activePlayersQueue.sync {
            activePlayers.removeAll { $0 === player }
        }
    }
} 
