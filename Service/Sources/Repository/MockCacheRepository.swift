//
//  MockCacheRepository.swift
//  Service
//
//  Created by 신동규 on 9/14/25.
//

import Foundation
import Domain

public final class MockCacheRepository: CacheRepository {

    private var cachedNews: [NewsEntity] = []

    public init() {
        // Pre-populate with some mock cached data for previews
        cachedNews = [
            NewsEntity(
                id: 101,
                title: "[CACHED] Apple Stock Rises on AI Announcement",
                summarize: "Apple's latest AI features announcement drives stock price up in pre-market trading.",
                url: URL(string: "https://example.com/apple-ai"),
                published_date: Date().addingTimeInterval(-7200), // 2 hours ago
                score: 7,
                tickers: ["AAPL", "MSFT"],
                created_at: Date().addingTimeInterval(-7200),
                save: Bool.random()
            ),
            NewsEntity(
                id: 102,
                title: "[CACHED] Federal Reserve Meeting Results",
                summarize: "Fed maintains current interest rates, signaling stable monetary policy ahead.",
                url: URL(string: "https://example.com/fed-meeting"),
                published_date: Date().addingTimeInterval(-14400), // 4 hours ago
                score: 5,
                tickers: ["SPY", "QQQ", "JPM"],
                created_at: Date().addingTimeInterval(-14400),
                save: Bool.random()
            )
        ]
    }

    public func getNews() -> [NewsEntity] {
        return cachedNews.sorted { $0.published_date > $1.published_date }
    }

    public func saveNews(_ news: [NewsEntity]) {
        for item in news {
            // Add only if not already cached
            if !cachedNews.contains(where: { $0.id == item.id }) {
                cachedNews.append(item)
            }
        }
        print("Mock: Cached \(news.count) news items")
    }

    public func clearAllNewsData() {
        cachedNews.removeAll()
        print("Mock: Cleared all news data")
    }
}
