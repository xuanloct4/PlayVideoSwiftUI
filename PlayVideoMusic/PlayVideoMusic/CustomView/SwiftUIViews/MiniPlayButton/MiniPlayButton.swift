//
//  MiniPlayButton.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 22/12/2022.
//

import SwiftUI

struct MiniPlayButton: View {
    private var action: (() -> Void)? = nil
    let imageName: String
    let width: CGFloat
    let height: CGFloat
    
    init(action: (() -> Void)? = nil, imageName: String, width: CGFloat, height: CGFloat) {
        self.action = action
        self.imageName = imageName
        self.width = width
        self.height = height
    }
    
    var body: some View {
        Button {
            action?()
        } label: {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
        }
    }
}

struct MiniPlayButton_Previews: PreviewProvider {
    static var previews: some View {
        MiniPlayButton(imageName: Constant.AssetsImage.iconNextMiniatureButton,
                       width: 24,
                       height: 24)
    }
}

extension MiniPlayButton {
    func invokeMiniPlayButton(onAction: @escaping () -> Void) -> Self {
        var view = self
        view.action = onAction
        return view
    }
}
