//
//  PlayerControlsView.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 05/01/2023.
//

import SwiftUI

struct PlayerControlsView: View {
    @ObservedObject var playerVM: PlayerViewModel
    
    @State var isRepeat: Bool = false
    
    var body: some View {
        VStack {
            timerNormalControlPlayView
            normalControlPlayView
        }
    }
}

struct PlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlsView(playerVM: PlayerViewModel())
    }
}

extension PlayerControlsView {
    private var timerNormalControlPlayView: some View {
        HStack {
            Text("\(Utility.formatSecondsToHMS(playerVM.currentTime))")
            Spacer()
            Text("\(Utility.formatSecondsToHMS(playerVM.duration ?? 0))")
        }
        .padding(.horizontal, 12)
    }
    
    private var normalControlPlayView: some View {
        HStack(alignment: .center, spacing: 40) {
            MiniPlayButton(imageName: Constant.AssetsImage.iconShuffleNormalButton,
                           width: 28,
                           height: 20)
            .invokeMiniPlayButton {
                
            }
            
            MiniPlayButton(imageName: Constant.AssetsImage.iconPreviousNormalButton,
                           width: 28,
                           height: 20)
            .invokeMiniPlayButton(onAction: playerVM.invokeBackwardVideo)
            MiniPlayButton(imageName: playerVM.playVideoState == .playing ? Constant.AssetsImage.iconPauseNormalButton : Constant.AssetsImage.iconPlayNormalButton,
                           width: 40,
                           height: 40)
            .invokeMiniPlayButton {
                if playerVM.playVideoState == .paused {
                    playerVM.player.play()
                } else {
                    playerVM.player.pause()
                }
            }
            
            MiniPlayButton(imageName: Constant.AssetsImage.iconNextNormalButton,
                           width: 28,
                           height: 20)
            .invokeMiniPlayButton(onAction: playerVM.invokeForwardVideo)
            
            MiniPlayButton(imageName: Constant.AssetsImage.iconRepeatNormalButton,
                           width: 28,
                           height: 20)
            .invokeMiniPlayButton {
                isRepeat = !isRepeat
                if isRepeat {
                    playerVM.repeatVideo()
                } else {
                    playerVM.removeRepeatVideo()
                }
            }
        }
    }
}
