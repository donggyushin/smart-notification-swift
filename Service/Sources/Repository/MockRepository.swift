//
//  MockRepository.swift
//  Service
//
//  Created by 신동규 on 9/9/25.
//

import Foundation
import Domain

public final class MockRepository: Repository {
    public func save(news: NewsEntity, save: Bool) async throws -> NewsEntity {
        var news = news
        news.save = save
        return news
    }
    
    public func getSavedNewsFeed(cursor_id: Int?) async throws -> NewsResponse {
        try await getNewsFeed(cursor_id: cursor_id)
    }
    
    public init() {}
    
    public func postDevice(device_uuid: String, fcm_token: String) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        print("Mock: Device registered - UUID: \(device_uuid), FCM: \(fcm_token)")
    }
    
    public func getNewsFeed(cursor_id: Int?) async throws -> NewsResponse {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        let mockNews = [
            NewsEntity(
                id: 1,
                title: "Federal Reserve Signals Interest Rate Changes Ahead",
                summarize: "The Federal Reserve indicated potential monetary policy adjustments in response to inflation data, which could significantly impact technology and financial stocks.",
                url: URL(string: "https://example.com/fed-rate-news"),
                published_date: Date().addingTimeInterval(-3600), // 1 hour ago
                score: 8,
                tickers: ["AAPL", "MSFT", "JPM", "BAC"],
                created_at: Date().addingTimeInterval(-3600),
                save: false
            ),
            NewsEntity(
                id: 2,
                title: "Major Tech Earnings Beat Expectations",
                summarize: "Several major technology companies reported quarterly earnings that exceeded analyst expectations, driving optimism in the sector.",
                url: URL(string: "https://example.com/tech-earnings"),
                published_date: Date().addingTimeInterval(-7200), // 2 hours ago
                score: 6,
                tickers: ["GOOGL", "AMZN", "META", "NFLX"],
                created_at: Date().addingTimeInterval(-7200),
                save: Bool.random()
            ),
            NewsEntity(
                id: 3,
                title: "Oil Prices Surge on Supply Concerns",
                summarize: "Crude oil prices jumped following reports of supply disruptions, potentially affecting energy sector stocks and broader market inflation.",
                url: URL(string: "https://example.com/oil-prices"),
                published_date: Date().addingTimeInterval(-10800), // 3 hours ago
                score: -4,
                tickers: ["XOM", "CVX", "BP", "SLB"],
                created_at: Date().addingTimeInterval(-10800),
                save: Bool.random()
            )
        ]
        
        return NewsResponse(
            items: mockNews,
            next_cursor_id: cursor_id == nil ? 123 : nil,
            has_more: cursor_id == nil,
            limit: 10
        )
    }
    
    public func getNews(id: Int) async throws -> NewsEntity {
        let response = try await getNewsFeed(cursor_id: nil)
        return response.items.randomElement()!
    }
}
