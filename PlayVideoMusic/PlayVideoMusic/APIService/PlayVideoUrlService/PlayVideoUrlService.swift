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
    func fetchInfomationVideo(with videoId: String) -> AnyPublisher<MiniPlayerModel, APIError> {
        let apiPath = String(format: baseApiPath, videoId)
        guard let urlComponents = URLComponents(string: apiPath),
              let url = urlComponents.url,
              let userId = Constant.KeyServices.uuid else {
            return Fail(error: APIError.errorURL).eraseToAnyPublisher()
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
        return BaseApiService.shared.request(from: urlRequest)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
