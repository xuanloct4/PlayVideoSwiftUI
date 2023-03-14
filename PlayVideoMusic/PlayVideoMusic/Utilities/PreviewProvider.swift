//
//  PreviewProvider.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 30/11/2022.
//

import Foundation
import SwiftUI

let darkBlack = Color(red: 17/255, green: 18/255, blue: 19/255)
let darkGray = Color(red: 41/255, green: 42/255, blue: 48/255)
let darkBlue = Color(red: 96/255, green: 174/255, blue: 201/255)
let darkPink = Color(red: 244/255, green: 132/255, blue: 177/255)
let darkViolet = Color(red: 214/255, green: 189/255, blue: 251/255)
let darkGreen = Color(red: 137/255, green: 192/255, blue: 180/255)

let clearWhite = Color(red: 17/255, green: 18/255, blue: 19/255)
let clearGray = Color(red: 181/255, green: 182/255, blue: 183/255)
let clearBlue = Color(red: 116/255, green: 166/255, blue: 240/255)

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() { }
    let snippet: Snippet = Snippet(publishedAt: "2022-08-13T12:30:14Z",
                                   channelID: "UCGFCgx-jgSKgq1kKMUQRPXA",
                                   title: "TILO Official",
                                   snippetDescription: "Mixtape Việt Mix & House Lak | Vì Mẹ Anh Bắt Chia Tay - Bên Trên Tầng Lầu | TiLo Mix ➡️ Tham gia làm hội viên của kênh này ...",
                                   thumbnails: Thumbnails(thumbnailsDefault: Default(url: "https://i.ytimg.com/vi/i-IiDtCtQDQ/default.jpg",
                                                                                     width: 120,
                                                                                     height: 90),
                                                          medium: Default(url: "https://i.ytimg.com/vi/i-IiDtCtQDQ/mqdefault.jpg",
                                                                          width: 320,
                                                                          height: 180),
                                                          high: Default(url: "https://i.ytimg.com/vi/i-IiDtCtQDQ/hqdefault.jpg",
                                                                        width: 480,
                                                                        height: 360)
                                   ),
                                   channelTitle: "TILO Official",
                                   liveBroadcastContent: "none",
                                   publishTime: "2022-08-13T12:30:14Z")
    
    let searchVideoPreview: SearchVideoModel = SearchVideoModel(
        kind: "youtube#searchListResponse",
        etag: "aUd-u8CExOLOU6HABxHZkYb_JJk",
        pageInfo: PageInfo(totalResults: 683946,
                           resultsPerPage: 25),
        items: [
            Item(kind: "youtube#searchResult",
                 etag: "cqGYu7SxkE4ijggv8Lsltc2qk9A",
                 idVideo: IDVideo(kind: "youtube#channel",
                                  videoID: nil,
                                  channelID: "UCGFCgx-jgSKgq1kKMUQRPXA"),
                 snippet: Snippet(publishedAt: "2018-10-09T09:05:21Z",
                                  channelID: "UCGFCgx-jgSKgq1kKMUQRPXA",
                                  title: "TILO Official",
                                  snippetDescription: "hi, đây là kênh YouTube chính thức của DJ Tilo, kênh phát hành các ca khúc nhạc trẻ việt mix, nhạc remix với style đặc trưng, hay ...",
                                  thumbnails: Thumbnails(thumbnailsDefault: Default(url: "https://yt3.ggpht.com/ytc/AMLnZu_cSfcgJFxzQvuTe6Lfjnxu6CrYSKnBVghHkIRv=s88-c-k-c0xffffffff-no-rj-mo",
                                                                                    width: nil,
                                                                                    height: nil),
                                                         medium: Default(url: "https://yt3.ggpht.com/ytc/AMLnZu_cSfcgJFxzQvuTe6Lfjnxu6CrYSKnBVghHkIRv=s240-c-k-c0xffffffff-no-rj-mo",
                                                                         width: nil,
                                                                         height: nil),
                                                         high: Default(url: "https://yt3.ggpht.com/ytc/AMLnZu_cSfcgJFxzQvuTe6Lfjnxu6CrYSKnBVghHkIRv=s800-c-k-c0xffffffff-no-rj-mo",
                                                                       width: nil,
                                                                       height: nil)
                                  ),
                                  channelTitle: "TILO Official",
                                  liveBroadcastContent: "upcoming",
                                  publishTime: "2018-10-09T09:05:21Z")),
            Item(kind: "youtube#searchResult",
                 etag: "ahS7Z3w8zTHyGKHPnd-ydaKetSU",
                 idVideo: IDVideo(kind: "youtube#video",
                                  videoID: "i-IiDtCtQDQ",
                                  channelID: nil),
                 snippet: Snippet(publishedAt: "2022-08-13T12:30:14Z",
                                  channelID: "UCGFCgx-jgSKgq1kKMUQRPXA",
                                  title: "Mixtape Việt Mix &amp; House Lak | Vì Mẹ Anh Bắt Chia Tay - Bên Trên Tầng Lầu | TiLo Mix",
                                  snippetDescription: "Mixtape Việt Mix & House Lak | Vì Mẹ Anh Bắt Chia Tay - Bên Trên Tầng Lầu | TiLo Mix ➡️ Tham gia làm hội viên của kênh này ...",
                                  thumbnails: Thumbnails(thumbnailsDefault: Default(url: "https://i.ytimg.com/vi/i-IiDtCtQDQ/default.jpg",
                                                                                    width: 120,
                                                                                    height: 90),
                                                         medium: Default(url: "https://i.ytimg.com/vi/i-IiDtCtQDQ/mqdefault.jpg",
                                                                         width: 320,
                                                                         height: 180),
                                                         high: Default(url: "https://i.ytimg.com/vi/i-IiDtCtQDQ/hqdefault.jpg",
                                                                       width: 480,
                                                                       height: 360)
                                  ),
                                  channelTitle: "TILO Official",
                                  liveBroadcastContent: "none",
                                  publishTime: "2022-08-13T12:30:14Z"))
        ]
    )
    
    let itemSelected: Item = Item(kind: "youtube#searchResult",
                                  etag: "ahS7Z3w8zTHyGKHPnd-ydaKetSU",
                                  idVideo: IDVideo(kind: "youtube#video",
                                                   videoID: "i-IiDtCtQDQ",
                                                   channelID: nil),
                                  snippet: Snippet(publishedAt: "2022-08-13T12:30:14Z",
                                                   channelID: "UCGFCgx-jgSKgq1kKMUQRPXA",
                                                   title: "Mixtape Việt Mix &amp; House Lak | Vì Mẹ Anh Bắt Chia Tay - Bên Trên Tầng Lầu | TiLo Mix",
                                                   snippetDescription: "Mixtape Việt Mix & House Lak | Vì Mẹ Anh Bắt Chia Tay - Bên Trên Tầng Lầu | TiLo Mix ➡️ Tham gia làm hội viên của kênh này ...",
                                                   thumbnails: Thumbnails(thumbnailsDefault: Default(url: "https://i.ytimg.com/vi/i-IiDtCtQDQ/default.jpg",
                                                                                                     width: 120,
                                                                                                     height: 90),
                                                                          medium: Default(url: "https://i.ytimg.com/vi/i-IiDtCtQDQ/mqdefault.jpg",
                                                                                          width: 320,
                                                                                          height: 180),
                                                                          high: Default(url: "https://i.ytimg.com/vi/i-IiDtCtQDQ/hqdefault.jpg",
                                                                                        width: 480,
                                                                                        height: 360)
                                                   ),
                                                   channelTitle: "TILO Official",
                                                   liveBroadcastContent: "none",
                                                   publishTime: "2022-08-13T12:30:14Z"))
}

