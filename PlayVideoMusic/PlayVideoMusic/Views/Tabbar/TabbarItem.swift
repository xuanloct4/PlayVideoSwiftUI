//
//  TabbarItem.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 20/12/2022.
//

import Foundation
import SwiftUI

enum TabbarItem: Hashable {
    case home
    case playlist
    case search
    case setting
    
    var iconName: String {
        switch self {
        case .home:
            return Constant.AssetsImage.iconTabbarHome
        case .playlist:
            return Constant.AssetsImage.iconTabbarPlaylists
        case .search:
            return Constant.AssetsImage.iconTabbarSearch
        case .setting:
            return Constant.AssetsImage.iconTabbarSetting
        }
    }
    
    var iconNameSelected: String {
        switch self {
        case .home:
            return Constant.AssetsImage.iconTabbarHomeSelected
        case .playlist:
            return Constant.AssetsImage.iconTabbarPlaylistsSelected
        case .search:
            return Constant.AssetsImage.iconTabbarSearchSelected
        case .setting:
            return Constant.AssetsImage.iconTabbarSettingSelected
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .playlist:
            return "Playlists"
        case .search:
            return "Search"
        case .setting:
            return "Setting"
        }
    }
}
