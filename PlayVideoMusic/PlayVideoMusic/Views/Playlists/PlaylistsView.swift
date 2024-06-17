//
//  PlaylistsView.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 20/12/2022.
//

import SwiftUI
import CoreData

class VideoPlaylistObservable: ObservableObject {
    class VideoPlaylist: ObservableObject {
        @Published var videoId: String?
        @Published var format: String?
        @Published var quality: String?
        @Published var localFile: String?
        
        init(videoId: String? = nil,
             format: String? = nil,
             quality: String? = nil,
             localFile: String? = nil) {
            self.videoId = videoId
            self.format = format
            self.quality = quality
            self.localFile = localFile
        }
    }
    @State var showingPopover: Bool
    @Published var videoInfo: VideoPlaylist
    
    init(showingPopover: Bool = false,
         videoInfo: VideoPlaylist = VideoPlaylist()) {
        self.showingPopover = showingPopover
        self.videoInfo = videoInfo
    }
}

struct PlaylistsView: View {
    @Environment(\.managedObjectContext) var coreData
    @EnvironmentObject var player: MiniPlayerViewModel
    @ObservedObject var playerViewModel: PlayerViewModel
    @FetchRequest(sortDescriptors: []) var videos: FetchedResults<Video>
    
    @State private var showingPopover = false
    @State private var videoPlaylist: VideoPlaylistObservable = VideoPlaylistObservable.init(showingPopover: false,
                                                                                             videoInfo: .init())
    
    //    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
    
    @State var message = "XXXX"
    @State var alertAction: AlertAction?
    @State var isSuccess = true
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(videos) { video in
                        PlaylistsRow(video: video,
                                     showingPopover: $showingPopover,
                                     videoPlaylist: $videoPlaylist)
                        .onTapGesture {
                            print(video)
                            withAnimation {
                                self.player.isNormalPlayer = true
                            }
                            self.player.isShowPlayer = true
                            
                            do {
                                if let local = video.localURL {
                                    let url = try FileOperation.getLocalURL(fileName: local)
                                    self.playerViewModel.setCurrentItem(with: url)
                                }
                            } catch {
                                print(error)
                            }
                            
                        }
                    }
                    .onDelete(perform: removeVideo)
                }
            }
            if showingPopover {
                AlertView(shown: $showingPopover, closureA: $alertAction, isSuccess: isSuccess, message: message)
            }
           
                //            .popup(isPresented: $videoPlaylist.showingPopover) {
                //                       ZStack {
                //                           Color.gray.frame(width: 300, height: 500)
                //                           Text("Popup!")
                //                       }
                //                   }
                //            .popover(isPresented: $videoPlaylist.showingPopover) {
                //                VStack {
                //                    Text(videoPlaylist.videoInfo.quality ?? "")
                //                        .font(.headline)
                //                        .padding()
                //                    Button {
                //
                //                    } label: {
                //                        Text("Fetch video Info")
                //                            .font(.headline)
                //                            .padding()
                //                    }
                //                    .frame(width: 200, height: 72)
                //                }
                //            }
                
              
        }
    }
    
    func removeVideo(at offsets: IndexSet) {
        
        for index in offsets {
            let video = videos[index]
            if let localURL = video.localURL,
               let fileURL = try? FileOperation.getLocalURL(fileName: localURL) {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                    print("Removed video: \(video)")
                    print("local path: \(fileURL)")
                } catch {
                    print(error)
                }
                coreData.delete(video)
                print("CoreData removed video: \(video)")
            }
        }
        
        do {
            try coreData.save()
        } catch {
            print(error)
        }
    }
}

//struct PlaylistsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaylistsView(, playerViewModel: <#PlayerViewModel#>)
//    }
//}
