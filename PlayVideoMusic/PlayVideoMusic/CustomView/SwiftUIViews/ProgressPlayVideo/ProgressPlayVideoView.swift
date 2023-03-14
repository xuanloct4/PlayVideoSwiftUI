//
//  ProgressPlayVideoView.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 05/01/2023.
//

import SwiftUI

struct ProgressPlayVideoView: View {
    @StateObject var viewModel: ProgressPlayVideoViewModel
    
    @State private var shouldAnimate = false
    @State var isShowProgress: Bool
    
    init(snippet: Snippet, isShowProgress: Bool) {
        self.isShowProgress = isShowProgress
        _viewModel = StateObject(wrappedValue: ProgressPlayVideoViewModel(snippet: snippet))
    }
    
    var body: some View {
        if isShowProgress {
            ZStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                SpinnerView()
//                VStack {
//                    HStack {
//                        Circle()
//                            .fill(Colors.colorFFFFFF)
//                            .frame(width: 20, height: 20)
//                            .scaleEffect(shouldAnimate ? 1.0 : 0.5)
//                            .animation(Animation.easeInOut(duration: 0.5).repeatForever())
//                        Circle()
//                            .fill(Colors.colorFFFFFF)
//                            .frame(width: 20, height: 20)
//                            .scaleEffect(shouldAnimate ? 1.0 : 0.5)
//                            .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3))
//                        Circle()
//                            .fill(Colors.colorFFFFFF)
//                            .frame(width: 20, height: 20)
//                            .scaleEffect(shouldAnimate ? 1.0 : 0.5)
//                            .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6))
//                    }
//                    .onAppear {
//                        self.shouldAnimate = true
//                    }
//                }
            }
        }
    }
}

struct ProgressPlayVideoView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressPlayVideoView(snippet: dev.snippet, isShowProgress: true)
            .previewLayout(.sizeThatFits)
    }
}
