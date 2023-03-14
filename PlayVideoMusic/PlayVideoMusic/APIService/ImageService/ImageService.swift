//
//  ImageService.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 01/12/2022.
//

import Foundation
import SwiftUI
import Combine

class ImageService {
    @Published var image: UIImage? = nil
    
    var imageSubscription: AnyCancellable?
    
    init(urlString: String) {
        getImage(urlString: urlString)
    }
    
    private func getImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        imageSubscription = BaseApiService.request(from: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: BaseApiService.handleCompletion, receiveValue: { image in
                self.image = image
                self.imageSubscription?.cancel()
            })
    }
}
