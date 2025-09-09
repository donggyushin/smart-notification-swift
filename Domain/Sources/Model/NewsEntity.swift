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

public struct NewsEntity {
    public let id: Int
    public let title: String
    public let summarize: String
    public let url: URL?
    public let published_date: Date
    public let score: Int
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
