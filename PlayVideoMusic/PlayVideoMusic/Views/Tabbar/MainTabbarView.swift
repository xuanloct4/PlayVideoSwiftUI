//
//  MainTabbarView.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 20/12/2022.
//

import SwiftUI

struct MainTabbarView: View {
    @State private var tabSelection: TabbarItem = .search
    
    @ObservedObject var player = MiniPlayerViewModel()
    
    @Namespace var animation
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabbarContainerView(selection: $tabSelection) {
                HomeView()
                    .tabbarItem(tab: .home, selection: $tabSelection)
                PlaylistsView()
                    .tabbarItem(tab: .playlist, selection: $tabSelection)
                SearchView()
                    .tabbarItem(tab: .search, selection: $tabSelection)
                SettingView()
                    .tabbarItem(tab: .setting, selection: $tabSelection)
            }
            if player.isShowPlayer {
                MiniPlayerView(animation: animation)
            }
        }
        .environmentObject(player)
    }
}

struct MainTabbarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbarView()
    }
}
