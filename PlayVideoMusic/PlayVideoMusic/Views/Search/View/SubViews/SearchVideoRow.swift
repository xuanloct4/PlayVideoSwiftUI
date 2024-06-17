//
//  SearchVideoRow.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 30/11/2022.
//

import SwiftUI
import CoreData
import Combine

struct SearchVideoRow: View {
    @Binding var showingPopover: Bool
//    let snippet: Snippet
    let item: Item
    
    @Environment(\.managedObjectContext) var videoCoreData
    @StateObject var downloader = VideoDownloaderViewModel()
    
    var snippet: Snippet {
        return item.snippet ?? Snippet(publishedAt: nil,
                                       channelID: nil,
                                       title:
                                        nil,
                                       snippetDescription: nil,
                                       thumbnails: nil,
                                       channelTitle: nil,
                                       liveBroadcastContent: nil,
                                       publishTime: nil)
    }
    var body: some View {
        ZStack {
            Colors.color161A1A
            HStack() {
                VideoImageView(snippet: snippet)
                    .frame(width: 120, height: 72)
                    .cornerRadius(8)
                
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Colors.color99999F, lineWidth: 1)
                    )
                VStack(alignment: .leading, spacing: 4) {
                    Text(snippet.title ?? "")
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .foregroundColor(Colors.colorFFFFFF)
                    Text(snippet.channelTitle ?? "")
                        .font(.subheadline)
                        .foregroundColor(Colors.color99999F)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack(spacing: 8) {
                    Button {
                        downloader.videoCoreData = videoCoreData
                        downloader.audioOnly = false
                        downloader.item = item
                        //                    showingPopover = true
                        //                    downloader.$fileLocalURL
                        //                        .filter { $0 != nil }
                        //                        .sink { _ in
                        //                            saveCoreData()
                        //                        }
                        //                        .store(in: &downloader.subscriptions)
                    } label: {
                        Image(Constant.AssetsImage.iconDownload)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: 32, height: 32)
                    Button {
                        downloader.videoCoreData = videoCoreData
                        downloader.audioOnly = true
                        downloader.item = item
                        //                    showingPopover = true
                        //                    downloader.$fileLocalURL
                        //                        .filter { $0 != nil }
                        //                        .sink { _ in
                        //                            saveCoreData()
                        //                        }
                        //                        .store(in: &downloader.subscriptions)
                    } label: {
                        Image(Constant.AssetsImage.iconTabbarPlaylists)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: 24, height: 24)
                }
                
            }
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
            .frame(maxWidth: .infinity)
            .background(Colors.color161A1A)
        }
    }
}

//struct SearchVideoRow_Previews: PreviewProvider {
   
//    static var previews: some View {
//        @State private var showingPopover = false
//        SearchVideoRow(snippet: dev.snippet, showingPopover: showingPopover)
//            .previewLayout(.sizeThatFits)
//    }
//}
