//
//  TabbarItemsPreferenceKey.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 20/12/2022.
//

import Foundation
import SwiftUI

struct TabbarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [TabbarItem] = []
    
    static func reduce(value: inout [TabbarItem], nextValue: () -> [TabbarItem]) {
        value += nextValue()
    }
}

struct TabbarItemViewModifier: ViewModifier {
    let tab: TabbarItem
    @Binding var selection: TabbarItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabbarItemsPreferenceKey.self, value: [tab])
    }
}

extension View {
    func tabbarItem(tab: TabbarItem, selection: Binding<TabbarItem>) -> some View {
        modifier(TabbarItemViewModifier(tab: tab, selection: selection))
    }
}
