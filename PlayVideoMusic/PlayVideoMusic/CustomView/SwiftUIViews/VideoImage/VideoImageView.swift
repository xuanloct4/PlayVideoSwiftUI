//
//  VideoImageView.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 01/12/2022.
//

import SwiftUI

struct VideoImageView: View {
    @StateObject var viewModel: VideoImageModel

    init(snippet: Snippet) {
        _viewModel = StateObject(wrappedValue: VideoImageModel(snippet: snippet))
    }
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Colors.color303033)
            }
        }
    }
}

struct VideoImageView_Previews: PreviewProvider {
    static var previews: some View {
        VideoImageView(snippet: dev.snippet)
            .previewLayout(.sizeThatFits)
    }
}
