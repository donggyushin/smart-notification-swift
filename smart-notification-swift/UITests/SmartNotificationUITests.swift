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
}
