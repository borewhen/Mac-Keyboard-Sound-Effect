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
        // In Xcode projects, use Bundle.main for resources
        print("SoundPlayer: Attempting to load soundbite...")
        guard let soundURL = Bundle.main.url(forResource: "soundbite", withExtension: "wav") else {
            print("SoundPlayer: Could not find soundbite.wav in Bundle.main")
            return
        }
        
        print("SoundPlayer: Found soundbite at: \(soundURL)")
        do {
            soundData = try Data(contentsOf: soundURL)
            print("SoundPlayer: Soundbite loaded successfully, size: \(soundData?.count ?? 0) bytes")
        } catch {
            print("SoundPlayer: Failed to load soundbite: \(error)")
            soundData = nil
        }
    }

    func playKeySound() {
        guard let data = soundData else { 
            print("SoundPlayer: No sound data available")
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
            if success {
                print("SoundPlayer: Audio playback started successfully")
            } else {
                print("SoundPlayer: Failed to start audio playback")
            }
        } catch {
            print("SoundPlayer: Error creating audio player: \(error)")
        }
    }

    // AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        activePlayersQueue.sync {
            activePlayers.removeAll { $0 === player }
        }
    }
} 