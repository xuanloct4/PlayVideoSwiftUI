//
//  SearchVideoModel.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 30/11/2022.
//

import Foundation

// MARK: - SearchVideoGetRequest
struct SearchPredictGetRequest {
    let client: String
    let description: String
    let languageType: String
    let formatType: String
}
// MARK: - SearchVideoGetRequest
struct SearchVideoGetRequest {
    var part: String
    var maxResults: Int
}

// MARK: - ChannelResponse
struct SearchVideoModel: Codable {
    let kind, etag, nextPageToken, regionCode: String?
    let pageInfo: PageInfo
    let items: [Item]?
}

// MARK: - Item
struct Item: Identifiable, Codable {
    var id: UUID = UUID()
    let kind: String?
    let etag: String?
    let idVideo: IDVideo
    let snippet: Snippet?
    
    enum CodingKeys: String, CodingKey {
        case kind
        case etag
        case idVideo = "id"
        case snippet
    }
}

// MARK: - ID
struct IDVideo: Codable {
    let kind: String?
    let videoID: String?
    let channelID: String?
    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
        case channelID = "channelId"
    }
}

// MARK: - Snippet
struct Snippet: Codable {
    let publishedAt: String?
    let channelID: String?
    let title: String?
    let snippetDescription: String?
    let thumbnails: Thumbnails?
    let channelTitle: String?
    let liveBroadcastContent: String?
    let publishTime: String?

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title
        case snippetDescription = "description"
        case thumbnails, channelTitle, liveBroadcastContent, publishTime
    }
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    let thumbnailsDefault, medium, high: Default?

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high
    }
}

// MARK: - Default
struct Default: Codable {
    let url: String?
    let width, height: Int?
}

// MARK: - PageInfo
struct PageInfo: Codable {
    let totalResults, resultsPerPage: Int?
}
