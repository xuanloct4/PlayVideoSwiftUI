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
    func fetchSearchVideo(result: String) {
        let request = SearchVideoGetRequest(part: "snippet", maxResults: 25)
        let queryItems = [URLQueryItem(name: "part", value: request.part),
                          URLQueryItem(name: "maxResults", value: String(request.maxResults)),
                          URLQueryItem(name: "key", value: Constant.KeyServices.apiKey),
                          URLQueryItem(name: "q", value: result)]
        let apiPath = String(format: baseApiPath, youtubeSearchService)
        guard var urlComponents = URLComponents(string: apiPath) else {
            return
        }

        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            return
        }
        debugPrint("🟠 URL REQUEST: \(url)")
        searchVideoSubscription = BaseApiService.request(from: url)
            .decode(type: SearchVideoModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: BaseApiService.handleCompletion, receiveValue: { searchVideos in
           	     self.items = searchVideos.items ?? []
                self.searchVideoSubscription?.cancel()
            })
    }
}
