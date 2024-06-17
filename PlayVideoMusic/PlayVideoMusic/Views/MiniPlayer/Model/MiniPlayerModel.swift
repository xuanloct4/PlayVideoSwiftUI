//
//  MiniPlayerModel.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 27/12/2022.
//

import Foundation

// MARK: - Welcome
struct MiniPlayerModel: Codable {
    let videoId, ip, userCountryCode, status: String
    let extractorType, extractorMethod: String?
    let metaInfo: MetaInfo
    let videoStatistics: VideoStatistics?
    let qualities: [Quality]
    let youtubeVideoMaxQuality: YoutubeVideoMaxQuality?

    enum CodingKeys: String, CodingKey {
        case videoId, ip, userCountryCode, status, extractorType, extractorMethod, metaInfo, videoStatistics, qualities, youtubeVideoMaxQuality
    }
}

// MARK: - MetaInfo
struct MetaInfo: Codable {
    let title: String
    let duration, expires: Int
    let isLive, isHLS: Bool
    let thumbnailUrls: ThumbnailUrls

    enum CodingKeys: String, CodingKey {
        case title, duration, expires, isLive
        case isHLS = "isHls"
        case thumbnailUrls
    }
}

// MARK: - ThumbnailUrls
struct ThumbnailUrls: Codable {
    let hq, mq, thumbnailUrlsDefault: String

    enum CodingKeys: String, CodingKey {
        case hq, mq
        case thumbnailUrlsDefault = "default"
    }
}

// MARK: - Quality
struct Quality: Codable {
    let isDash: Bool
    let url: String
    let urls: [String]
    let length: Int
    let qualityInfo: YoutubeVideoMaxQuality
}

// MARK: - YoutubeVideoMaxQuality
struct YoutubeVideoMaxQuality: Codable {
    let itag: Int?
    let format, qualityLabel: String?
    let type, audioBitrate: Int
}

// MARK: - VideoStatistics
struct VideoStatistics: Codable {
    let proxyUsageVariant, protectedStatus, clientRequestStatus, cacheStatus: Int
    let country, controllerName, clientIP, browser: String
    let platform, userID: String
    let isProtected: Bool

    enum CodingKeys: String, CodingKey {
        case proxyUsageVariant, protectedStatus, clientRequestStatus, cacheStatus, country, controllerName
        case clientIP = "clientIp"
        case browser, platform
        case userID = "userId"
        case isProtected
    }
}
