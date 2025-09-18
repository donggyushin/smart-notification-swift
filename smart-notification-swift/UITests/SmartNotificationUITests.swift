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

    // Test that NewsListView displays news items and navigate to NewsDetailView and open safari for stock item
    func test_open_stock_full_article() async throws {
        // Wait for API response (1 seconds should be enough because there is cache system)
        try await Task.sleep(for: .seconds(1))

        // SwiftUI List appears as a CollectionView in this case
        let newsList = await app.collectionViews["newsList"]
        
        let cells = await newsList.cells
        let firstCell = await cells.firstMatch
        
        // Tap first cell to navigation to NewsDetailView
        await firstCell.tap()
        try await Task.sleep(for: .seconds(1))
        
        // Check for Summary section
        let summaryText = await app.staticTexts["Summary"]
        let summaryTextExist = await summaryText.exists
        XCTAssertTrue(summaryTextExist)
        
        // Check Navigation Title.
        let newsDetailNavigationBar = await app.navigationBars["News Detail"]
        let newsDetailNavigationBarExist = await newsDetailNavigationBar.exists
        XCTAssertTrue(newsDetailNavigationBarExist)
        
        // Check safari opened
        let safariButton = await app.buttons["Read Full Article"]
        
        await safariButton.tap()
        
        let safariApp = await XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        let safariRunning = await safariApp.wait(for: .runningForeground, timeout: 3)
        XCTAssertTrue(safariRunning)
    }

}
