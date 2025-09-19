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

    func test_NewsDTO_toDomain_withInvalidURL() {
        let newsDTO = NewsDTO(
            id: 3,
            title: "Invalid URL Test",
            summarize: "Testing invalid URL handling",
            url: nil,
            published_date: "2025-09-19T10:30:00Z",
            score: 0,
            tickers: [],
            created_at: "2025-09-19T10:30:00Z"
        )

        let newsEntity = newsDTO.toDomain()

        XCTAssertEqual(newsEntity.id, 3)
        XCTAssertNil(newsEntity.url)
        XCTAssertEqual(newsEntity.score, 0)
        XCTAssertEqual(newsEntity.tickers, [])
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
}
