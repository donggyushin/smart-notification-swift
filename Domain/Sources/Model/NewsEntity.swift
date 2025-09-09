//
//  NewsEntity.swift
//  Domain
//
//  Created by 신동규 on 9/9/25.
//

import Foundation

public struct NewsResponse {
    public let items: [NewsEntity]
    public let next_cursor_id: Int?
    public let has_more: Bool
    public let limit: Int
    
    public init(items: [NewsEntity], next_cursor_id: Int?, has_more: Bool, limit: Int) {
        self.items = items
        self.next_cursor_id = next_cursor_id
        self.has_more = has_more
        self.limit = limit
    }
}

/// Represents a news article that has been analyzed by CrewAI for its potential impact on the US stock market.
/// The server searches for news with high potential impact and provides analysis and scoring.
public struct NewsEntity {
    /// Unique identifier for the news article
    public let id: Int
    /// Title of the news article
    public let title: String
    /// AI-generated summary of the news content
    public let summarize: String
    /// Original URL of the news article, if available
    public let url: URL?
    /// Date when the news was published
    public let published_date: Date
    /// Impact score assigned by AI analysis (higher score indicates greater potential market impact) (-10 ~ 10)
    public let score: Int
    /// Stock tickers that may be affected by this news
    public let tickers: [String]
    
    public init(id: Int, title: String, summarize: String, url: URL?, published_date: Date, score: Int, tickers: [String]) {
        self.id = id
        self.title = title
        self.summarize = summarize
        self.url = url
        self.published_date = published_date
        self.score = score
        self.tickers = tickers
    }
}
