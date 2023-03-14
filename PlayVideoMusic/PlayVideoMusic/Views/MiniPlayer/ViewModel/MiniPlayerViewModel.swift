//
//  MiniPlayerViewModel.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 27/12/2022.
//

import Foundation
import SwiftUI
import Combine

class MiniPlayerViewModel: ObservableObject {
    // MARK: Object Selected Play Video
    var item: Item? {
        didSet {
            loadInfoVideo(videoId: item?.idVideo.videoID ?? "")
        }
    }
    @Published var miniPlayData: MiniPlayerModel?
    
    // MARK: MiniPlayer properties
    @Published var isShowPlayer = false
    @Published var isHaveUrl = false
    // MARK: Gesture offset
    @Published var offset: CGFloat = 0
    @Published var width: CGFloat = UIScreen.main.bounds.width
    @Published var height: CGFloat = 0
    @Published var isNormalPlayer = true
    @Published var thumbImage: UIImage? = nil
    
    // MARK: Handle Video
    private let dataSearchVideoService = PlayVideoUrlService()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func loadInfoVideo(videoId: String) {
        dataSearchVideoService.fetchInfomationVideo(with: videoId)
        dataSearchVideoService.$miniPlayerModel
            .sink { [weak self] miniPlayer in
                guard let self = self else {
                    return
                }
                self.isHaveUrl = true
                self.miniPlayData = miniPlayer
            }
            .store(in: &subscriptions)
    }
}
