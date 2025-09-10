//
//  NewsDTO.swift
//  Service
//
//  Created by 신동규 on 9/9/25.
//

import Foundation
import Domain

public struct NewsResponseDTO: Codable {
    let items: [NewsDTO]
    let next_cursor_id: Int?
    let has_more: Bool
    let limit: Int
    
    public func toDomain() -> NewsResponse {
        return NewsResponse(
            items: items.map { $0.toDomain() },
            next_cursor_id: next_cursor_id,
            has_more: has_more,
            limit: limit
        )
    }
}

public struct NewsDTO: Codable {
    let id: Int
    let title: String
    let summarize: String
    let url: String?
    let published_date: String
    let score: Int
    let tickers: [String]
    
    public func toDomain() -> NewsEntity {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: published_date) ?? Date()
        let newsURL = url.flatMap { URL(string: $0) }
        
        return NewsEntity(
            id: id,
            title: title,
            summarize: summarize,
            url: newsURL,
            published_date: date,
            score: score,
            tickers: tickers
        )
    }
}
