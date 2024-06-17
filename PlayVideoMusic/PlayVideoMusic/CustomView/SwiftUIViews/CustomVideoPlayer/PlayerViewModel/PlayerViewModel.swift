//
//  PlayerViewModel.swift
//  DemoPlayVideoSwiftUI
//
//  Created by AnhND47.APL on 19/12/2022.
//

import AVFoundation
import Combine
import AVKit

enum PlayVideoState {
    case playing
    case paused
    case waitingToPlayAtSpecifiedRate
}

final class PlayerViewModel: ObservableObject {
    lazy var player: AVPlayer = {
        let player = AVPlayer()
        let playerLayer = AVPlayerLayer()

        playerLayer.player = player
//        layer.addSublayer(playerLayer)
//        playerLayer.videoGravity = .resizeAspect
//        playerLayer.frame = self.bounds
//
//        if let playerLayer = playerLayer {
            if AVPictureInPictureController.isPictureInPictureSupported() {
                let pipController = AVPictureInPictureController(playerLayer: playerLayer)!
            }
//        }
        
        return player
    }()
    
    @Published var isInPipMode: Bool = true
    
    @Published var isEditingCurrentTime = false
    @Published var currentTime: Double = .zero
    @Published var duration: Double?
    @Published var durationObservation: NSKeyValueObservation?
    
    @Published var playVideoState: PlayVideoState = .waitingToPlayAtSpecifiedRate
    
    private var subscriptions: Set<AnyCancellable> = []
    private var timeObserver: Any?
    
    var statusVideo: AVPlayer.TimeControlStatus = .waitingToPlayAtSpecifiedRate
    var notificationObserver: NSObjectProtocol?
    
    deinit {
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }
    
    init() {
        $isEditingCurrentTime
            .dropFirst()
            .filter({ $0 == false })
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.player.seek(to: CMTime(seconds: self.currentTime, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                if self.player.rate != 0 {
                    self.player.play()
                }
            })
            .store(in: &subscriptions)
        
        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                guard let self = self else {
                    return
                }
                switch status {
                case .playing:
                    self.playVideoState = .playing
                case .paused:
                    self.playVideoState = .paused
                case .waitingToPlayAtSpecifiedRate:
                    self.playVideoState = .waitingToPlayAtSpecifiedRate
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)
       
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self else { return }
            if self.isEditingCurrentTime == false {
                self.currentTime = time.seconds
            }
        }
        
        durationObservation = player.currentItem?.observe(\.duration, changeHandler: { [weak self] item, change in
            guard let self = self else { return }
            self.duration = item.duration.seconds / self.currentTime
        })
    }
    
    func setCurrentItem(_ item: AVPlayerItem) {
        currentTime = .zero
        duration = nil
        player.replaceCurrentItem(with: item)
        player.play()
        
        item.publisher(for: \.status)
            .filter({ $0 == .readyToPlay })
            .sink(receiveValue: { [weak self] _ in
                self?.duration = item.asset.duration.seconds
            })
            .store(in: &subscriptions)
    }
    
    func setCurrentItem(with url: URL) {
        let avPlayerItem = AVPlayerItem(url: url)
        currentTime = .zero
        duration = nil
        player.replaceCurrentItem(with: avPlayerItem)
        player.play()
        
        avPlayerItem.publisher(for: \.status)
            .filter({ $0 == .readyToPlay })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.duration = avPlayerItem.asset.duration.seconds
            })
            .store(in: &subscriptions)
    }
    
    func invokeForwardVideo() {
        forwardVideo(by: 10)
    }
    
    func invokeBackwardVideo() {
        backwardVideo(by: 10)
    }
    
    private func backwardVideo(by seconds: Float64) {
        let currentTime = player.currentTime()
        let playerCurrentTime = CMTimeGetSeconds(currentTime)
        var newTime = playerCurrentTime - seconds
        if newTime <= 0 {
            newTime = 0
        }
        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player.seek(to: time2)
    }
    
    private func forwardVideo(by seconds: Float64) {
        guard let duration  = player.currentItem?.duration else {
            return
        }
        let currentTime = player.currentTime()
        let playerCurrentTime = CMTimeGetSeconds(currentTime)
        let newTime = playerCurrentTime + seconds
        
        if newTime < CMTimeGetSeconds(duration) {
            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player.seek(to: time2)
        }
    }
    
    func repeatVideo() {
        notificationObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: .main, using: { _ in
            self.player.seek(to: .zero)
            self.player.play()
        })
    }
    
    func removeRepeatVideo() {
        if let notificationObserver = notificationObserver {
            NotificationCenter.default.removeObserver(notificationObserver)
        }
    }
}
