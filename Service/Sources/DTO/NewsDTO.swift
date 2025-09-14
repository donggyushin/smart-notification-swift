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
    let created_at: String
    
    public func toDomain() -> NewsEntity {
        let newsURL = url.flatMap { URL(string: $0) }
        let publishedDate = parseDate(from: published_date)
        let createdAtDate = parseDate(from: created_at)

        return NewsEntity(
            id: id,
            title: title,
            summarize: summarize,
            url: newsURL,
            published_date: publishedDate,
            score: score,
            tickers: tickers,
            created_at: createdAtDate
        )
    }

    private func parseDate(from dateString: String) -> Date {
        // Try ISO8601 with fractional seconds and timezone
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = iso8601Formatter.date(from: dateString) {
            return date
        }

        // Fallback to basic ISO8601 format
        iso8601Formatter.formatOptions = [.withInternetDateTime]
        if let date = iso8601Formatter.date(from: dateString) {
            return date
        }

        // Last resort fallback
        return Date()
    }
}
