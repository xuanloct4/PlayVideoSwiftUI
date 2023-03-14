//
//  BaseHeaderContainerView.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 06/12/2022.
//

import SwiftUI

struct BaseHeaderContainerView<Content: View>: View {
    let content: Content
    
    // Property
    @State private var title: String = ""
    @State private var isShowBackButton: Bool = true
    @State private var isShowRightButton: Bool = false
    @State private var backgroundColorHeader: Color = Colors.color161A1A
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            BaseNavigationBarView(title: title,
                                  isShowBackButton: isShowBackButton,
                                  isShowRightButton: isShowRightButton,
                                  backgroundColorHeader: backgroundColorHeader)
            content.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onPreferenceChange(BaseHeaderTitlePreferenceKey.self) { value in
            self.title = value
        }
        .onPreferenceChange(BaseHeaderBackButtonHiddenPreferenceKey.self) { value in
            self.isShowBackButton = !value
        }
        .onPreferenceChange(BaseHeaderRightButtonHiddenPreferenceKey.self) { value in
            self.isShowRightButton = !value
        }
        .onPreferenceChange(BaseHeaderBackgroundColorPreferenceKey.self) { value in
            self.backgroundColorHeader = value
        }
    }
}

struct       Model_Previews: PreviewProvider {
    static var previews: some View {
        BaseHeaderContainerView(content: {
            ZStack {
                Color.green.ignoresSafeArea()
                Text("Hello, world!")
                    .foregroundColor(.white)
                    .baseHeaderTitle("Title")
            }
        })
    }
}
