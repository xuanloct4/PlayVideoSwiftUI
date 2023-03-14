//
//  BaseHeaderNavigationView.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 06/12/2022.
//

import SwiftUI

struct BaseHeaderNavigationView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            BaseHeaderContainerView {
                content
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct BaseHeaderNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        BaseHeaderNavigationView {
            Color.orange.ignoresSafeArea()
        }
    }
}
