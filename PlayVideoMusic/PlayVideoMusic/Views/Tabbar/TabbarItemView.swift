//
//  TabbarItemView.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 20/12/2022.
//

import SwiftUI

struct TabbarItemView: View {
    let tabItems: [TabbarItem]
    
    @Binding var selection: TabbarItem
    @Namespace private var nameSpace
    @State var localSelection: TabbarItem
    
    var body: some View {
        tabbarItems
            .onChange(of: selection) { newValue in
                withAnimation(.easeInOut) {
                    localSelection = newValue
                }
            }
    }
}

struct TabbarItemView_Previews: PreviewProvider {
    static let tabs: [TabbarItem] = [.home, .playlist, .search, .setting]
    
    static var previews: some View {
        TabbarItemView(tabItems: tabs, selection: .constant(.playlist), localSelection: .playlist)
    }
}

extension TabbarItemView {
    private func switchToTab(tab: TabbarItem) {
            selection = tab
    }
    
    private var tabbarVersion1: some View {
        HStack {
            ForEach(tabItems, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(4)
        .background(Colors.color161A1A.ignoresSafeArea(edges: .bottom))
    }
}

extension TabbarItemView {
    private func tabView(tab: TabbarItem) -> some View {
        VStack {
            Image(localSelection == tab ? tab.iconNameSelected : tab.iconName)
            Text(tab.title)
                .foregroundColor(localSelection == tab ? Colors.colorD9519D : Colors.color63666E)
                .font(.system(size: 10,
                              weight: .semibold,
                              design: .rounded))
                
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
    }
    
    private var tabbarItems: some View {
        HStack {
            ForEach(tabItems, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(4)
        .background(Colors.color161A1A.ignoresSafeArea(edges: .bottom))
        .shadow(color: .black.opacity(0.9),radius: 10, x: 0, y: 5)
    }
}

