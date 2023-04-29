//
//  SearchVideoViewModel.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 30/11/2022.
//

import Foundation
import Combine

class SearchVideoViewModel: ObservableObject {
    @Published var searchPredictVideo: String = ""
    
    @Published var videoItems: [Item] = []
    @Published var suggestItems: [String] = []
    
    private let dataSearchPredictService = SearchPredictService()
    private let dataSearchVideoService = SearchService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchPredictVideo
            .sink(receiveValue: loadDataSearchPredict(query:))
            .store(in: &cancellables)
    }
}

extension SearchVideoViewModel {
    func loadVideoWhenSelectedResult(result: String) {
        dataSearchVideoService.fetchSearchVideo(result: result)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                print("ANHND47 status: \(status)")
            }, receiveValue: { [weak self] videos in
                if let items = videos.items {
                    self?.videoItems = items
                }
            })
            .store(in: &cancellables)
    }
}

extension SearchVideoViewModel {
    private func loadDataSearchPredict(query: String) {
        dataSearchPredictService.fetchSearchResult(query: query)
            .decode(type: [String].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { status in
                print("ANHND47 status: \(status)")
            }, receiveValue: { [weak self] items in
                DispatchQueue.main.async {
                    self?.suggestItems = items
                }
            })
    }
}
