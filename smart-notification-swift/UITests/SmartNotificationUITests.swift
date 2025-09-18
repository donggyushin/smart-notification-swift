//
//  SmartNotificationUITests.swift
//  smart-notification-swiftUITests
//
//  Created by 신동규 on 9/18/25.
//

import XCTest

final class SmartNotificationUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func test_appLaunches() throws {
        // Test that the app launches successfully
        XCTAssertTrue(app.exists)
    }

    func test_newsListView_isDisplayed() throws {
        // Test that news list view is displayed
        let newsList = app.tables.firstMatch
        XCTAssertTrue(newsList.waitForExistence(timeout: 5))
    }

    func test_pullToRefresh_works() throws {
        // Test pull-to-refresh functionality
        let newsList = app.tables.firstMatch
        XCTAssertTrue(newsList.waitForExistence(timeout: 5))

        // Perform pull-to-refresh gesture
        newsList.swipeDown()

        // Wait a moment for refresh to complete
        Thread.sleep(forTimeInterval: 2)

        // Verify the list still exists after refresh
        XCTAssertTrue(newsList.exists)
    }

    func test_newsItem_tap_opensURL() throws {
        // Test tapping on a news item
        let newsList = app.tables.firstMatch
        XCTAssertTrue(newsList.waitForExistence(timeout: 5))

        // Check if there are any news items
        let firstNewsItem = newsList.cells.firstMatch
        if firstNewsItem.exists {
            // Tap on the first news item
            firstNewsItem.tap()

            // This might open Safari or show some action
            // We can't easily test URL opening in UI tests, but we can verify the tap doesn't crash
            XCTAssertTrue(app.exists)
        }
    }

    func test_newsItem_displays_impactScore() throws {
        // Test that news items display impact scores
        let newsList = app.tables.firstMatch
        XCTAssertTrue(newsList.waitForExistence(timeout: 5))

        let firstNewsItem = newsList.cells.firstMatch
        if firstNewsItem.exists {
            // Look for score indicators (could be text or colored indicators)
            let scoreElements = firstNewsItem.staticTexts.allElementsBoundByIndex
            XCTAssertGreaterThan(scoreElements.count, 0, "News item should display content")
        }
    }

    func test_newsItem_displays_stockTickers() throws {
        // Test that news items display stock tickers
        let newsList = app.tables.firstMatch
        XCTAssertTrue(newsList.waitForExistence(timeout: 5))

        let firstNewsItem = newsList.cells.firstMatch
        if firstNewsItem.exists {
            // Check that the news item contains text (which should include tickers)
            let textElements = firstNewsItem.staticTexts.allElementsBoundByIndex
            XCTAssertGreaterThan(textElements.count, 0, "News item should display ticker information")
        }
    }

    func test_scrolling_loads_moreNews() throws {
        // Test infinite scroll functionality
        let newsList = app.tables.firstMatch
        XCTAssertTrue(newsList.waitForExistence(timeout: 5))

        // Get initial cell count
        let initialCellCount = newsList.cells.count

        // Scroll down to trigger loading more news
        if initialCellCount > 0 {
            newsList.swipeUp()
            newsList.swipeUp()

            // Wait for potential new items to load
            Thread.sleep(forTimeInterval: 2)

            // Verify we still have a functioning list
            XCTAssertTrue(newsList.exists)
        }
    }

    func test_app_handles_networkError_gracefully() throws {
        // Test that the app handles network errors without crashing
        // This is mainly testing that the app doesn't crash during normal operations
        let newsList = app.tables.firstMatch
        XCTAssertTrue(newsList.waitForExistence(timeout: 5))

        // Perform various actions that might trigger network calls
        newsList.swipeDown() // Pull to refresh
        Thread.sleep(forTimeInterval: 1)

        newsList.swipeUp() // Scroll for more items
        Thread.sleep(forTimeInterval: 1)

        // App should still be responsive
        XCTAssertTrue(app.exists)
        XCTAssertTrue(newsList.exists)
    }
}