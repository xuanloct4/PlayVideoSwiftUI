//
//  VideoImageModel.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 01/12/2022.
//

import Foundation
import SwiftUI
import Combine

class VideoImageModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let snippet: Snippet
    private let dataService: ImageService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(snippet: Snippet) {
        self.snippet = snippet
        self.dataService = ImageService(urlString: snippet.thumbnails?.medium?.url ?? "")
        self.addSubscripbers()
        self.isLoading = true
    }
    
    func addSubscripbers() {
        dataService.$image
            .sink { [weak self] (_) in
                guard let self = self else {
                    return
                }
                self.isLoading = false
            } receiveValue: { [weak self] image in
                guard let self = self else {
                    return
                }
                self.image = image
            }
            .store(in: &cancellables)
    }
}
