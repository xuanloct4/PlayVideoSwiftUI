//
//  Constant.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 20/12/2022.
//

import Foundation
import UIKit
struct Constant {
    struct KeyServices {
        static let apiKey = "AIzaSyCrhiwQK3_uHUM0XTL6WiyfT_MEUO7pSTQ"
        static let uuid = UIDevice.current.identifierForVendor?.uuidString
    }
    
    struct PreviewContentView {
        static let iconHomeTabbar: String = "ic_home"
        static let iconHomeTabbarSelected: String = "ic_home_selected"
        static let homeTabName: String = "Home"
    }
    
    struct HTTPMethod {
        static let getMethod = "GET"
        static let postMethod = "POST"
        static let putMethod = "PUT"
    }
    
    struct AssetsImage {
        static let iconLogo: String = "ic_logo"
        static let iconSearch: String = "ic_search"
        // Icon Tabbar Item
        static let iconTabbarHomeSelected: String = "ic_tabbar_home_selected"
        static let iconTabbarHome: String = "ic_tabbar_home"
        static let iconTabbarSetting: String = "ic_tabbar_setting"
        static let iconTabbarSettingSelected: String = "ic_tabbar_setting_selected"
        static let iconTabbarPlaylists: String = "ic_tabbar_playlists"
        static let iconTabbarPlaylistsSelected: String = "ic_tabbar_playlists_selected"
        static let iconTabbarSearch: String = "ic_tabbar_search"
        static let iconTabbarSearchSelected: String = "ic_tabbar_search_selected"
        
        static let iconBackButton: String = "ic_back_button"
        
        // PlayVideo
        static let iconNextMiniatureButton: String = "ic_next_miniature"
        static let iconPlayMiniatureButton: String = "ic_play_miniature"
        static let iconPreviousMiniatureButton: String = "ic_previous_miniature"
        static let iconPauseMiniatureButton: String = "ic_pause_miniature"
        
        static let iconNextNormalButton: String = "ic_next_normal"
        static let iconPlayNormalButton: String = "ic_play_normal"
        static let iconPreviousNormalButton: String = "ic_previous_normal"
        static let iconPauseNormalButton: String = "ic_pause_normal"
        static let iconShuffleNormalButton: String = "ic_shuffle_normal"
        static let iconRepeatNormalButton: String = "ic_repeat_normal"
    }
}
