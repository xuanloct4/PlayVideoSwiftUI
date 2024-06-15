//
//  CustomVideoPlayer.swift
//  DemoPlayVideoSwiftUI
//
//  Created by AnhND47.APL on 19/12/2022.
//

import SwiftUI
import AVKit
import Combine

struct CustomVideoPlayer: UIViewRepresentable {
    @ObservedObject var playerVM: PlayerViewModel
    
    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.player = playerVM.player
        context.coordinator.setController(view.playerLayer)
        return view
    }
    
    func updateUIView(_ uiView: PlayerView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, AVPictureInPictureControllerDelegate {
        private let parent: CustomVideoPlayer
        private var controller: AVPictureInPictureController?
        private var cancellable: AnyCancellable?
        private var subscriptions: Set<AnyCancellable> = []
        init(_ parent: CustomVideoPlayer) {
            self.parent = parent
            super.init()
            
            cancellable = parent.playerVM.$isInPipMode
                .sink { [weak self] in
                    guard let self = self,
                          let controller = self.controller else { return }
                    if $0 {
                        if controller.isPictureInPictureActive == false {
                            controller.startPictureInPicture()
                        }
                    } else if controller.isPictureInPictureActive {
                        controller.stopPictureInPicture()
                    }
                }
            cancellable?.store(in: &subscriptions)
        }
        
        func setController(_ playerLayer: AVPlayerLayer) {
            if AVPictureInPictureController.isPictureInPictureSupported() {
                controller = AVPictureInPictureController(playerLayer: playerLayer)
               }
            if #available(iOS 14.2, *) {
                controller?.canStartPictureInPictureAutomaticallyFromInline = true
            } else {
                // Fallback on earlier versions
            }
            
            controller?.delegate = self
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                if self?.controller?.isPictureInPictureActive == false {
                    self?.controller?.startPictureInPicture()
                }
            }
        }
        
        func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            parent.playerVM.isInPipMode = true
        }
        
        func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            parent.playerVM.isInPipMode = false
        }
    }
}
