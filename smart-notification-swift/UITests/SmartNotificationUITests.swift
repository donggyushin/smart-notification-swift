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
    
    func test_manage_shared_states() async throws {
        // Wait for API response
        try await Task.sleep(for: .seconds(5))
        
        let bookmarkImage = await app.collectionViews.firstMatch.cells.firstMatch.buttons["bookmark.fill"]
        let initialSaveStatus = await bookmarkImage.exists
        print(initialSaveStatus)
        
        // Move to Detail View.
        await app.collectionViews.firstMatch.cells.firstMatch.tap()
        
        // Wait for API response
        try await Task.sleep(for: .seconds(1))
        
        let saveButton = await app.buttons["saveButton"]
        
        // Change the value in Detail
        await saveButton.tap()
        
        // Wait for API response
        try await Task.sleep(for: .seconds(2))
        
        // Move back to list page
        await app.buttons["Market News"].tap()
        
        try await Task.sleep(for: .seconds(1))
        
        // Check the first cell's value is changed
        let bookmarkImage3 = await app.collectionViews.firstMatch.cells.firstMatch.buttons["bookmark.fill"]
        let initialSaveStatus3 = await bookmarkImage3.exists
        
        XCTAssertNotEqual(initialSaveStatus3, initialSaveStatus)
    }
    
    func test_change_tab_test() async throws {
        // Tap the "Saved" tab
        let savedTabButton = await app.tabBars.buttons["Saved"]
        await savedTabButton.tap()

        // Verify the navigation title changed to "Saved News"
        let savedNewsTitle = await app.navigationBars["Saved News"]
        let savedNewsTitleExists = await savedNewsTitle.exists
        XCTAssertTrue(savedNewsTitleExists)
        
        // Tap the "News" tab again
        let newsTabButton = await app.tabBars.buttons["News"]
        await newsTabButton.tap()
        
        // Verify now Saved News title is disappeared.
        let savedNewsTitle2 = await app.navigationBars["Saved News"]
        let savedNewsTitleExists2 = await savedNewsTitle2.exists
        XCTAssertFalse(savedNewsTitleExists2)
    }

    // Test that NewsListView displays news items and navigate to NewsDetailView and open safari for stock item
    func test_open_stock_full_article() async throws {
        // Wait for API response (1 seconds should be enough because there is cache system)
        try await Task.sleep(for: .seconds(1))

        // SwiftUI List appears as a CollectionView in this case
        let newsList = await app.collectionViews.firstMatch
        
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
