
import SwiftUI
import CoreData
import Combine

struct PlaylistsRow: View {
    let video: Video
    @Binding var showingPopover: Bool
    @Binding var videoPlaylist: VideoPlaylistObservable
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(alignment: .leading, content: {
                Text("\(video.title ?? "Unknown")")
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.black)
                                           .font(.headline)
                                           .lineSpacing(4)
                                           .textSelection(.enabled)
                Text("\(video.format ?? "")")
                    .foregroundStyle(.black)
                                            .font(.caption2)
                                            .textSelection(.enabled)
                Text("\(video.id ?? "")")
                    .foregroundStyle(.black)
                                            .font(.caption)
                                            .textSelection(.enabled)
            })
            Spacer(minLength: 0)
//            Button {
//                print("Delete Tap")
//                videoPlaylist.videoInfo = .init(videoId: video.id,
//                                                format: video.format,
//                                                quality: video.quality ?? "")
//                showingPopover = true
//            } label: {
//                Text("Delete")
//            }
//            .alignmentGuide(.trailing) { d in d[.trailing] }
//            .buttonBorderShape(.roundedRectangle)
//            .buttonStyle(.bordered)
//            .padding(0)
        }
   
//        ZStack {
//            Color(.white)
//            HStack(alignment: .center, spacing: 8) {
//                VStack(alignment: .leading, spacing: 0) {
//                    Text("\(video.title ?? "Unknown")")
//                        .foregroundStyle(.black)
//                        .font(.headline)
//                        .lineSpacing(4)
//                        .textSelection(.enabled)
//                    Text("\(video.format ?? "")")
//                        .foregroundStyle(.black)
//                        .font(.caption2)
//                        .textSelection(.enabled)
//                    Text("\(video.id ?? "")")
//                        .foregroundStyle(.black)
//                        .font(.caption)
//                        .textSelection(.enabled)
//                }
//                
////                Button {
////                    print("Delete Tap")
////                    videoPlaylist.videoInfo = .init(videoId: video.id,
////                                                    format: video.format,
////                                                    quality: video.quality ?? "")
////                    showingPopover = true
////                } label: {
////                    Text("Delete")
////                }
////                .buttonBorderShape(.roundedRectangle)
////                .buttonStyle(.bordered)
//            }
//            .frame(maxWidth: .infinity)
//           
//        }
        
    }
    
}
