//
//  TabbarContainerView.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 20/12/2022.
//

import SwiftUI

struct TabbarContainerView<Content: View>: View {
    @Binding var selection: TabbarItem
    @State private var tabs: [TabbarItem] = []
    
    let content: Content
    
    init(selection: Binding<TabbarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
//                .ignoresSafeArea()
            TabbarItemView(tabItems: tabs, selection: $selection, localSelection: selection)
        }
        .onPreferenceChange(TabbarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

//struct TabbarContainerView_Previews: PreviewProvider {
//    static let tabs: [TabbarItem] = [.home, .playlist, .search, .setting]
//
//    static var previews: some View {        
////        TabbarContainerView(selection: .constant(tabs.first!), content: {
////            Color.red
////        })
//        MainTabbarView()
//    }
//}
