//
//  DTOTests.swift
//  smart-notification-swiftTests
//
//  Created by 신동규 on 9/19/25.
//

@testable import smart_notification_swift
@testable import Service
@testable import Domain
import XCTest


final class DTOTests: XCTestCase {
    func test_NewsDTO_toDomain() {
        let newsDTO = NewsDTO(
            id: 1,
            title: "Apple Reports Strong Q4 Results",
            summarize: "Apple exceeded earnings expectations with strong iPhone sales",
            url: "https://example.com/news/apple-q4",
            published_date: "2025-09-19T10:30:00Z",
            score: 8,
            tickers: ["AAPL", "MSFT"],
            created_at: "2025-09-19T10:30:00Z"
        )

        let newsEntity = newsDTO.toDomain()

        XCTAssertEqual(newsEntity.id, 1)
        XCTAssertEqual(newsEntity.title, "Apple Reports Strong Q4 Results")
        XCTAssertEqual(newsEntity.summarize, "Apple exceeded earnings expectations with strong iPhone sales")
        XCTAssertEqual(newsEntity.url?.absoluteString, "https://example.com/news/apple-q4")
        XCTAssertEqual(newsEntity.score, 8)
        XCTAssertEqual(newsEntity.tickers, ["AAPL", "MSFT"])
    }

    func test_NewsDTO_toDomain_withNilURL() {
        let newsDTO = NewsDTO(
            id: 2,
            title: "Market Analysis",
            summarize: "General market overview",
            url: nil,
            published_date: "2025-09-19T10:30:00Z",
            score: -3,
            tickers: ["SPY"],
            created_at: "2025-09-19T10:30:00Z"
        )

        let newsEntity = newsDTO.toDomain()

        XCTAssertEqual(newsEntity.id, 2)
        XCTAssertEqual(newsEntity.title, "Market Analysis")
        XCTAssertNil(newsEntity.url)
        XCTAssertEqual(newsEntity.score, -3)
        XCTAssertEqual(newsEntity.tickers, ["SPY"])
    }

    func test_NewsResponseDTO_toDomain() {
        let newsDTO1 = NewsDTO(
            id: 1,
            title: "News 1",
            summarize: "Summary 1",
            url: "https://example.com/1",
            published_date: "2025-09-19T10:30:00Z",
            score: 5,
            tickers: ["AAPL"],
            created_at: "2025-09-19T10:30:00Z"
        )

        let newsDTO2 = NewsDTO(
            id: 2,
            title: "News 2",
            summarize: "Summary 2",
            url: "https://example.com/2",
            published_date: "2025-09-19T11:30:00Z",
            score: -2,
            tickers: ["GOOGL"],
            created_at: "2025-09-19T11:30:00Z"
        )

        let responseDTO = NewsResponseDTO(
            items: [newsDTO1, newsDTO2],
            next_cursor_id: 100,
            has_more: true,
            limit: 20
        )

        let response = responseDTO.toDomain()

        XCTAssertEqual(response.items.count, 2)
        XCTAssertEqual(response.items[0].id, 1)
        XCTAssertEqual(response.items[1].id, 2)
        XCTAssertEqual(response.next_cursor_id, 100)
        XCTAssertEqual(response.has_more, true)
        XCTAssertEqual(response.limit, 20)
    }

    func test_NewsResponseDTO_toDomain_withNilCursor() {
        let responseDTO = NewsResponseDTO(
            items: [],
            next_cursor_id: nil,
            has_more: false,
            limit: 10
        )

        let response = responseDTO.toDomain()

        XCTAssertEqual(response.items.count, 0)
        XCTAssertNil(response.next_cursor_id)
        XCTAssertEqual(response.has_more, false)
        XCTAssertEqual(response.limit, 10)
    }

    func test_NewsLocalDTO_initFromEntity() {
        let testURL = URL(string: "https://example.com/news")!
        let publishedDate = Date()
        let createdDate = Date().addingTimeInterval(-3600)

        let newsEntity = NewsEntity(
            id: 123,
            title: "Tesla Stock Surge",
            summarize: "Tesla shares rise on strong delivery numbers",
            url: testURL,
            published_date: publishedDate,
            score: 7,
            tickers: ["TSLA", "NIO"],
            created_at: createdDate
        )

        let localDTO = NewsLocalDTO(from: newsEntity)

        XCTAssertEqual(localDTO.id, 123)
        XCTAssertEqual(localDTO.title, "Tesla Stock Surge")
        XCTAssertEqual(localDTO.summarize, "Tesla shares rise on strong delivery numbers")
        XCTAssertEqual(localDTO.url, testURL)
        XCTAssertEqual(localDTO.published_date, publishedDate)
        XCTAssertEqual(localDTO.score, 7)
        XCTAssertEqual(localDTO.tickers, ["TSLA", "NIO"])
        XCTAssertEqual(localDTO.created_at, createdDate)
        XCTAssertTrue(localDTO.cached_at.timeIntervalSinceNow < 1)
    }

    func test_NewsLocalDTO_initFromEntity_withNilURL() {
        let publishedDate = Date()
        let createdDate = Date().addingTimeInterval(-3600)

        let newsEntity = NewsEntity(
            id: 456,
            title: "Market Update",
            summarize: "General market analysis",
            url: nil,
            published_date: publishedDate,
            score: -2,
            tickers: ["SPY"],
            created_at: createdDate
        )

        let localDTO = NewsLocalDTO(from: newsEntity)

        XCTAssertEqual(localDTO.id, 456)
        XCTAssertEqual(localDTO.title, "Market Update")
        XCTAssertNil(localDTO.url)
        XCTAssertEqual(localDTO.score, -2)
        XCTAssertEqual(localDTO.tickers, ["SPY"])
    }

    func test_NewsLocalDTO_toDomain() {
        let testURL = URL(string: "https://example.com/test")!
        let publishedDate = Date()
        let createdDate = Date().addingTimeInterval(-7200)
        let cachedDate = Date().addingTimeInterval(-1800)

        let localDTO = NewsLocalDTO(
            id: 789,
            title: "Apple Earnings Beat",
            summarize: "Apple reports strong quarterly results",
            url: testURL,
            published_date: publishedDate,
            score: 9,
            tickers: ["AAPL"],
            created_at: createdDate
        )

        let newsEntity = localDTO.toDomain()

        XCTAssertEqual(newsEntity.id, 789)
        XCTAssertEqual(newsEntity.title, "Apple Earnings Beat")
        XCTAssertEqual(newsEntity.summarize, "Apple reports strong quarterly results")
        XCTAssertEqual(newsEntity.url, testURL)
        XCTAssertEqual(newsEntity.published_date, publishedDate)
        XCTAssertEqual(newsEntity.score, 9)
        XCTAssertEqual(newsEntity.tickers, ["AAPL"])
        XCTAssertEqual(newsEntity.created_at, createdDate)
    }

    func test_NewsLocalDTO_roundTripConversion() {
        let originalEntity = NewsEntity(
            id: 999,
            title: "Round Trip Test",
            summarize: "Testing conversion integrity",
            url: URL(string: "https://roundtrip.com"),
            published_date: Date(),
            score: 5,
            tickers: ["TEST", "ROUND"],
            created_at: Date().addingTimeInterval(-3600)
        )

        let localDTO = NewsLocalDTO(from: originalEntity)
        let convertedEntity = localDTO.toDomain()

        XCTAssertEqual(originalEntity.id, convertedEntity.id)
        XCTAssertEqual(originalEntity.title, convertedEntity.title)
        XCTAssertEqual(originalEntity.summarize, convertedEntity.summarize)
        XCTAssertEqual(originalEntity.url, convertedEntity.url)
        XCTAssertEqual(originalEntity.published_date, convertedEntity.published_date)
        XCTAssertEqual(originalEntity.score, convertedEntity.score)
        XCTAssertEqual(originalEntity.tickers, convertedEntity.tickers)
        XCTAssertEqual(originalEntity.created_at, convertedEntity.created_at)
    }

    func test_NewsLocalDTO_cachedAtIsSet() {
        let beforeInit = Date()
        let localDTO = NewsLocalDTO(
            id: 1,
            title: "Cache Test",
            summarize: "Testing cache timestamp",
            url: nil,
            published_date: Date(),
            score: 0,
            tickers: [],
            created_at: Date()
        )
        let afterInit = Date()

        XCTAssertTrue(localDTO.cached_at >= beforeInit)
        XCTAssertTrue(localDTO.cached_at <= afterInit)
    }
}
