//
//  SearchView.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 20/12/2022.
//

import SwiftUI
import Combine

struct SearchView: View {
    @StateObject private var searchViewModel: SearchVideoViewModel = SearchVideoViewModel()

    @State private var isSearching: Bool = false
    @State private var isSearchSelected: Bool = false
    @EnvironmentObject var player: MiniPlayerViewModel
    
    @State private var showingPopover = false
    
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderSearchBarView(searchText: $searchViewModel.searchPredictVideo, isEditing: $isSearching, isSearchSelected: $isSearchSelected)
                .background(Colors.color161A1A)
                .padding(.top,  safeArea?.top)
            
            if !searchViewModel.searchPredictVideo.isEmpty && isSearchSelected {
                allListVideo
            } else {
                allListPredictResult
            }
        }
        .ignoresSafeArea()
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .popover(isPresented: $showingPopover) {
            VStack {
                Text("Popover")
                    .font(.headline)
                    .padding()
                Button {
                    
                } label: {
                    Text("Fetch video Info")
                        .font(.headline)
                        .padding()
                }
                    
                 
                    .frame(width: 200, height: 72)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

extension SearchView {
    private var allListPredictResult: some View {
        ZStack {
            Colors.color161A1A
            ScrollView {
                LazyVStack {
                    ForEach(searchViewModel.suggestItems, id: \.self) { item in
                        SearchAutoCompleteRow(content: item)
                        .onTapGesture {
                            searchViewModel.searchPredictVideo = item
                            isSearchSelected = true
                            searchViewModel.loadVideoWhenSelectedResult(result: item)
                            UIApplication.shared.endEditing()
                        }
                    }
                }
            }
        }
    }
    
    private var allListVideo: some View {
        ZStack {
            Colors.color161A1A
            ScrollView {
                LazyVStack {
                    ForEach(searchViewModel.videoItems) { item in
//                        if let snippet = item.snippet {
                        SearchVideoRow(showingPopover: $showingPopover, item: item)
                                .onTapGesture {
                                    withAnimation {
                                        self.player.isNormalPlayer = true
                                    }
                                    self.player.isShowPlayer = true
                                    self.player.item = item
                                    
                                   
                                }
//                        }
                    }
                }
            }
        }
    }
}
