//
//  MiniPlayerView.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 27/12/2022.
//

import SwiftUI
import AVFoundation

struct MiniPlayerView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var miniPlayer: MiniPlayerViewModel
    
    // MARK: Property Handle UI
    var animation: Namespace.ID
    var height = UIScreen.main.bounds.height / 3
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    let widthMiniatureVideoView: CGFloat = UIScreen.main.bounds.width / 5
  
    // MARK: Property Player Video z
    @StateObject var playerViewModel = PlayerViewModel()
    
    var body: some View {
        VStack(alignment: miniPlayer.isNormalPlayer ? .center : .leading) {
            HStack(spacing: 12) {
                if !miniPlayer.isNormalPlayer {
                    if let snippet = miniPlayer.item?.snippet {
                        VideoImageView(snippet: snippet)
                            .frame(width: miniPlayer.isNormalPlayer ? height : widthMiniatureVideoView,
                                   height: miniPlayer.isNormalPlayer ? height : widthMiniatureVideoView * 16 / 9)
                            .cornerRadius(15)
                            .padding(4)
                    }
                    miniInfoVideoView
                    Spacer(minLength: 0)
                    miniControlPlayView
                        .padding(8)
                }
            }
            .padding(.horizontal, 4)
            if miniPlayer.isNormalPlayer {
                if playerViewModel.playVideoState == .waitingToPlayAtSpecifiedRate {
                    if let snippet = miniPlayer.item?.snippet {
                        ProgressPlayVideoView(snippet: snippet, isShowProgress: true)
                            .frame(height: UIScreen.main.bounds.width * 9 / 16)
                            .padding(.top, safeArea?.top)
                    }
                } else {
                    ZStack {
                        CustomVideoPlayer(playerVM: playerViewModel)
                            .frame(height: UIScreen.main.bounds.width * 9 / 16)
                            .padding(.top, safeArea?.top)
                    }
                }
                if let duration = playerViewModel.duration {
                    Slider(value: $playerViewModel.currentTime, in: 0...duration, onEditingChanged: { isEditing in
                        playerViewModel.isEditingCurrentTime = isEditing
                    })
                }
                PlayerControlsView(playerVM: playerViewModel)
                Spacer()
            }
        }
        .onChange(of: miniPlayer.miniPlayData?.qualities.first?.url) { newvalue in
            if let url = URL(string: newvalue ?? "") {
                DispatchQueue.main.async {
                    playerViewModel.setCurrentItem(with: url)
                    playerViewModel.player.play()
                }
            }
        }
        
//                            .onChange(of: scenePhase) { oldPhase, newPhase in
//                                           if newPhase == .active {
//                                               print("Active")
//                                               playerViewModel.isInPipMode = false
//                                           } else if newPhase == .inactive {
//                                               playerViewModel.isInPipMode = true
//                                               print("Inactive")
//                                           } else if newPhase == .background {
//                                               print("Background")
//                                               playerViewModel.isInPipMode = true
//                                           }
//                                       }
        .onReceive(NotificationCenter.default.publisher(
            for: UIScene.didEnterBackgroundNotification)) { _ in
                playerViewModel.isInPipMode = true
            }
            .onReceive(NotificationCenter.default.publisher(
                for: UIScene.willEnterForegroundNotification)) { _ in
                    playerViewModel.isInPipMode = false
                }
        .frame(maxWidth: .infinity, maxHeight: miniPlayer.isNormalPlayer ? .infinity : 60)
        .background(
            backgroundPlayView
        )
        .cornerRadius(miniPlayer.isNormalPlayer ? 20 : 0)
        .offset(y: miniPlayer.isNormalPlayer ? 0 : -64)
        .offset(y: miniPlayer.offset)
        .gesture(
            DragGesture()
                .onEnded(onEnded(value:))
                .onChanged(onChanged(value:))
        )
        .ignoresSafeArea()
    }
}

// MARK: - Properties Mini Control Video
extension MiniPlayerView {
    private var backgroundPlayView: some View {
        VStack(spacing: 0) {
            BlurView()
            Divider()
        }
        .onTapGesture {
            withAnimation(.spring()) {
                self.miniPlayer.isNormalPlayer = true
            }
        }
    }
    
    private var miniInfoVideoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(miniPlayer.item?.snippet?.title ?? "")
                .font(.system(size: 14))
                .foregroundColor(Colors.colorFFFFFF)
                .fontWeight(.semibold)
                .lineLimit(1)
            Text(miniPlayer.item?.snippet?.channelTitle ?? "")
                .font(.system(size: 10))
                .foregroundColor(Colors.colorFFFFFF)
                .fontWeight(.regular)
            
        }
    }
    
    private var miniControlPlayView: some View {
        HStack(spacing: 12) {
            MiniPlayButton(imageName: playerViewModel.playVideoState == .playing ? Constant.AssetsImage.iconPauseMiniatureButton : Constant.AssetsImage.iconPlayMiniatureButton,
                           width: 32,
                           height: 32)
            .invokeMiniPlayButton {
                if playerViewModel.playVideoState == .paused {
                    playerViewModel.player.play()
                } else {
                    playerViewModel.player.pause()
                }
            }
            MiniPlayButton(imageName: Constant.AssetsImage.iconNextMiniatureButton,
                           width: 32,
                           height: 22)
            .invokeMiniPlayButton {
                
            }
        }
    }
}

// MARK: - Properties Normal Control Video
extension MiniPlayerView {
    
}

// MARK: - Private Method
extension MiniPlayerView {
    private func onChanged(value: DragGesture.Value) {
        if value.translation.height > 0 && miniPlayer.isNormalPlayer {
            miniPlayer.offset = value.translation.height
        }
    }
    
    private func onEnded(value: DragGesture.Value) {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)) {
            if value.translation.height > height {
                miniPlayer.isNormalPlayer = false
            }
            miniPlayer.offset = 0
        }
    }
    
    private func playVideoWithHaveUrl() {
        if let urlString = miniPlayer.miniPlayData?.qualities.first?.url, let url = URL(string: urlString) {
            playerViewModel.setCurrentItem(with: url)
        }
    }
}
