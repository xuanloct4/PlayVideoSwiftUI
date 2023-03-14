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
        dataSearchVideoService.$items
            .sink { [weak self] videos in
                self?.videoItems = videos
            }
            .store(in: &cancellables)
    }
}

extension SearchVideoViewModel {
    private func loadDataSearchPredict(query: String) {
        dataSearchPredictService.fetchSearchResult(query: query)
        dataSearchPredictService.$items
            .sink { [weak self] items in
                self?.suggestItems = items
            }
            .store(in: &cancellables)
    }
}
