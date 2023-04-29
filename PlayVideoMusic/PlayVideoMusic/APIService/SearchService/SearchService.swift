//
//  SearchService.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 30/11/2022.
//

import Foundation
import Combine

class SearchService {
    @Published var items: [Item] = []
    
    var searchVideoSubscription: AnyCancellable?
    
    let baseApiPath = "https://www.googleapis.com/youtube/v3/%@"
    let youtubeSearchService = "search"
    
    init() {
    }
}

extension SearchService {
    func fetchSearchVideo(result: String) -> AnyPublisher<SearchVideoModel, APIError> {
        let request = SearchVideoGetRequest(part: "snippet", maxResults: 25)
        let queryItems = [URLQueryItem(name: "part", value: request.part),
                          URLQueryItem(name: "maxResults", value: String(request.maxResults)),
                          URLQueryItem(name: "key", value: Constant.KeyServices.apiKey),
                          URLQueryItem(name: "q", value: result)]
        let apiPath = String(format: baseApiPath, youtubeSearchService)
        guard var urlComponents = URLComponents(string: apiPath) else {
            return Fail(error: APIError.errorURL).eraseToAnyPublisher()
        }

        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            return Fail(error: APIError.errorURL).eraseToAnyPublisher()
        }
        debugPrint("🟠 URL REQUEST: \(url)")
        return BaseApiService.shared.request(url: url)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
