//
//  PlayVideoUrlService.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 29/12/2022.
//

import Foundation
import Combine

class PlayVideoUrlService {
    @Published var miniPlayerModel: MiniPlayerModel?
    
    var playVideoUrlSubscription: AnyCancellable?
    let baseApiPath = "https://downloader.freemake.com/api/videoinfo/%@"
    
    init() {
    
    }
}

extension PlayVideoUrlService {
    func fetchInfomationVideo(with videoId: String) {
        let apiPath = String(format: baseApiPath, videoId)
        guard let urlComponents = URLComponents(string: apiPath),
              let url = urlComponents.url,
              let userId = Constant.KeyServices.uuid else {
            return
        }
        
        let httpHeader: [String: String] = [
            "x-user-id" : userId,
            "x-cf-country" : "VN",
            "x-analytics-header" : "UA-18256617-1",
            "referer" : "https://www.freemake.com/vi/free_video_downloader/",
            "origin" : "https://www.freemake.com",
        ]
        
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.allHTTPHeaderFields = httpHeader
        urlRequest.httpMethod = Constant.HTTPMethod.getMethod
        
//        playVideoUrlSubscription = BaseApiService.request(from: urlRequest)
//            .decode(type: MiniPlayerModel.self, decoder: JSONDecoder())
//            .sink(receiveCompletion: BaseApiService.handleCompletion, receiveValue: { miniPlayerModel in
//                self.miniPlayerModel = miniPlayerModel
//                self.playVideoUrlSubscription?.cancel()
//            })
    }
}
