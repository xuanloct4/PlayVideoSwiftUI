//
//  BaseHeaderPreferenceKey.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 06/12/2022.
//

import Foundation
import SwiftUI

struct BaseHeaderTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct BaseHeaderBackButtonHiddenPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct BaseHeaderRightButtonHiddenPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = true
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct BaseHeaderBackgroundColorPreferenceKey: PreferenceKey {
    static var defaultValue: Color = Colors.color161A1A
    
    static func reduce(value: inout Color, nextValue: () -> Color) {
        value = nextValue()
    }
}

extension View {
    func baseHeaderTitle(_ title: String) -> some View {
        preference(key: BaseHeaderTitlePreferenceKey.self, value: title)
    }
    
    func baseHeaderBackButtonHidden(_ hidden: Bool) -> some View {
        preference(key: BaseHeaderBackButtonHiddenPreferenceKey.self, value: hidden)
    }
    
    func baseHeaderRightButtonHidden(_ hidden: Bool) -> some View {
        preference(key: BaseHeaderRightButtonHiddenPreferenceKey.self, value: hidden)
    }
    
    func baseHeaderBackgroundColor(_ color: Color) -> some View {
        preference(key: BaseHeaderBackgroundColorPreferenceKey.self, value: color)
    }
    
    func customBaseHeaderItems(title: String = "",
                               backButtonHidden: Bool = false,
                               rightButtonHidden: Bool = true,
                               backgroundColor: Color) -> some View {
        self
            .baseHeaderTitle(title)
            .baseHeaderBackButtonHidden(backButtonHidden)
            .baseHeaderRightButtonHidden(rightButtonHidden)
            .baseHeaderBackgroundColor(backgroundColor)
    }
}
