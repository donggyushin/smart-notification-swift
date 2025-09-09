//
//  NewsEntity.swift
//  Domain
//
//  Created by 신동규 on 9/9/25.
//

import Foundation

public struct NewsResponse {
    let items: [NewsEntity]
    let next_cursor_id: Int?
    let has_more: Bool
    let limit: Int
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
