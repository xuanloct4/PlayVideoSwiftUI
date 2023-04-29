//
//  SearchPredictService.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 07/12/2022.
//

import Foundation
import Combine
//https://suggestqueries.google.com/complete/search?client=youtube&ds=yt&q=QUERY

class SearchPredictService {
    @Published var items: [String] = []
    
    var searchVideoSubscription: AnyCancellable?
    var queryString: String = ""
    
    let baseApiPath = "https://suggestqueries.google.com/complete/search"
    let youtubeSearchService = "search"
    
    init() {
    
    }
}

extension SearchPredictService {
    func fetchSearchResult(query: String) -> AnyPublisher<Data, APIError> {
        let request = SearchPredictGetRequest(client: "firefox", description: "yt", languageType: "en-gb", formatType: "vn")
        let queryItems = [URLQueryItem(name: "client", value: request.client),
                          URLQueryItem(name: "gl", value: request.formatType),
                          URLQueryItem(name: "hl", value: request.languageType),
                          URLQueryItem(name: "ds", value: request.description),
                          URLQueryItem(name: "q", value: query),
                          URLQueryItem(name: "ie", value: "utf-8")]
        let apiPath = String(format: baseApiPath, youtubeSearchService)
        guard var urlComponents = URLComponents(string: apiPath) else {
            return Fail(error: APIError.errorURL).eraseToAnyPublisher()
        }

        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            return Fail(error: APIError.errorURL).eraseToAnyPublisher()
        }
        debugPrint("🟠 URL REQUEST: \(url)")
        return BaseApiService.shared.requestNotObject(from: url)
            .eraseToAnyPublisher()
    }
}
