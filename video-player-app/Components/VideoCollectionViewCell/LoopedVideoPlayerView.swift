//
//  LoopedVideoPlayerView.swift
//  video-player-app
//
//  Created by Felipe Augusto Silva on 27/11/23.
//

import Foundation
import UIKit
import AVFoundation

final class LoopedVideoPlayerView: UIView {
    
    fileprivate var videoURL: URL? 
    fileprivate var queuePlayer: AVQueuePlayer?
    fileprivate var playerLayer: AVPlayerLayer?
    fileprivate var playbackLooper: AVPlayerLooper?
    fileprivate var audioPlayer: AVPlayer?
    
    func prepareVideo(_ videoURL: URL) {
        
        let playerItem = AVPlayerItem(url: videoURL)
        
        self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
        self.playerLayer = AVPlayerLayer(player: self.queuePlayer)
        guard let playerLayer = self.playerLayer else {return}
        guard let queuePlayer = self.queuePlayer else {return}
        self.playbackLooper = AVPlayerLooper.init(player: queuePlayer, templateItem: playerItem)
        
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.frame
        self.layer.addSublayer(playerLayer)
    }
    
    func play() {
        queuePlayer?.play()
        audioPlayer?.play()
    }
    
    func pause() {
        queuePlayer?.pause()
        audioPlayer?.pause()
    }
    
    func pauseOrPlay( paused: inout Bool) {
        if let player = queuePlayer {
            if player.rate == 0 && player.error == nil {
                player.play()
                audioPlayer?.play()
                paused = true
            } else {
                paused = false
                player.pause()
                audioPlayer?.pause()
            }
        }
    }
    
    func stop() {
        queuePlayer?.pause()
        queuePlayer?.seek(to: CMTime.init(seconds: 0, preferredTimescale: 1))
        audioPlayer?.pause()
        audioPlayer?.seek(to: CMTime.init(seconds: 0, preferredTimescale: 1))
    }
    
    func restartPlayer() {
        if let player = queuePlayer {
            if player.rate == 0 && player.error == nil {
                player.pause()
                player.seek(to: CMTime.init(seconds: 0, preferredTimescale: 1))
                player.play()
                
                audioPlayer?.pause()
                audioPlayer?.seek(to: CMTime.init(seconds: 0, preferredTimescale: 1))
                audioPlayer?.play()
            }
        }
    }
    
    func unload() {
        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
        self.queuePlayer = nil
        self.playbackLooper = nil
    }
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        self.playerLayer?.frame = self.bounds
    }
    
    // MARK: - Audio
    
    func playAudioFromURL(audioURL: String) {
        guard let url = URL(string: audioURL) else { return}
        
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
    }
}
