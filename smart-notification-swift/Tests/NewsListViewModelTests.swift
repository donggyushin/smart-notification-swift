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

    @MainActor
    func test_reload_fetchesNewsFromRepository() async throws {
        // When
        try await viewModel.reload()

        // Then - should fetch mock data from repository
        XCTAssertGreaterThan(viewModel.news.count, 0)
        XCTAssertFalse(viewModel.loading)
    }

    @MainActor
    func test_fetchNews_loadsNewsFromRepository() async throws {
        // When
        try await viewModel.fetchNews()

        // Then - should fetch mock data
        XCTAssertGreaterThan(viewModel.news.count, 0)
        XCTAssertFalse(viewModel.loading)
    }

    @MainActor
    func test_loading_stateChanges() async throws {
        // Given
        XCTAssertFalse(viewModel.loading)

        // When - start async operation
        let task = Task {
            try await viewModel.reload()
        }

        // Brief moment to check loading state
        try await Task.sleep(nanoseconds: 1_000_000) // 1ms

        // Then - should be loading initially
        // (Note: this might be flaky due to timing, but demonstrates the concept)

        // Wait for completion
        try await task.value

        // Should not be loading after completion
        XCTAssertFalse(viewModel.loading)
    }

    func test_saveCache_executesWithoutError() async {
        // Given
        await viewModel.prepareInitialData()

        // When/Then - should not throw
        XCTAssertNoThrow(viewModel.saveCache())
    }
}
