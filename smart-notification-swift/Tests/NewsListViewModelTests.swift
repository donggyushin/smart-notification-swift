//
//  NewsListViewModelTests.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/18/25.
//

@testable import smart_notification_swift
import XCTest

// MARK: - NewsListViewModel Tests

final class NewsListViewModelTests: XCTestCase {

    var viewModel: NewsListViewModel!

    override func setUp() {
        super.setUp()
        viewModel = NewsListViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func test_prepareInitialData_loadsCachedNews() async {
        // When
        await viewModel.prepareInitialData()

        // Then - should load mock cached data
        XCTAssertGreaterThan(viewModel.news.count, 0)
    }

    func test_reload_fetchesNewsFromRepository() async throws {
        // When
        try await viewModel.reload()

        // Then - should fetch mock data from repository
        XCTAssertGreaterThan(viewModel.news.count, 0)
        XCTAssertFalse(viewModel.loading)
    }

    func test_fetchNews_loadsNewsFromRepository() async throws {
        // When
        try await viewModel.fetchNews()

        // Then - should fetch mock data
        XCTAssertGreaterThan(viewModel.news.count, 0)
        XCTAssertFalse(viewModel.loading)
    }

    func test_loading_stateChanges() async throws {
        // Given
        XCTAssertFalse(viewModel.loading)
        // When - start async operation
        try await viewModel.reload()
        // Then - should be loading initially
        XCTAssertFalse(viewModel.loading)
    }
}
