//
//  ProgressPlayVideoViewModel.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 05/01/2023.
//

import Foundation
import SwiftUI
import Combine

class ProgressPlayVideoViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    private let snippet: Snippet
    private let dataService: ImageService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(snippet: Snippet) {
        self.snippet = snippet
        self.dataService = ImageService(urlString: snippet.thumbnails?.medium?.url ?? "")
        self.addSubscripbers()
    }
    
    func addSubscripbers() {
        dataService.$image
            .sink { [weak self] image in
                guard let self = self else {
                    return
                }
                self.image = image
            }
            .store(in: &cancellables)
    }
}
