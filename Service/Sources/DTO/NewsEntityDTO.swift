//
//  NewsEntityDTO.swift
//  Service
//
//  Created by Claude on 9/14/25.
//

import Foundation
import SwiftData
import Domain

@Model
final class NewsEntityDTO {
    @Attribute(.unique) var id: Int
    var title: String
    var summarize: String
    var url: URL?
    var published_date: Date
    var score: Int
    var tickers: [String]
    var cached_at: Date
    var created_at: Date

    init(id: Int, title: String, summarize: String, url: URL?, published_date: Date, score: Int, tickers: [String], created_at: Date) {
        self.id = id
        self.title = title
        self.summarize = summarize
        self.url = url
        self.published_date = published_date
        self.score = score
        self.tickers = tickers
        self.cached_at = Date()
        self.created_at = created_at
    }

    // Convert from Domain Entity to DTO
    convenience init(from entity: NewsEntity) {
        self.init(
            id: entity.id,
            title: entity.title,
            summarize: entity.summarize,
            url: entity.url,
            published_date: entity.published_date,
            score: entity.score,
            tickers: entity.tickers,
            created_at: entity.created_at
        )
    }

    // Convert from DTO to Domain Entity
    func toDomain() -> NewsEntity {
        return NewsEntity(
            id: self.id,
            title: self.title,
            summarize: self.summarize,
            url: self.url,
            published_date: self.published_date,
            score: self.score,
            tickers: self.tickers,
            created_at: self.created_at
        )
    }
}
