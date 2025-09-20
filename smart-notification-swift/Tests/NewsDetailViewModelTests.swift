//
//  NewsDetailViewModelTests.swift
//  smart-notification-swiftTests
//
//  Created by 신동규 on 9/20/25.
//

@testable import smart_notification_swift
import XCTest

final class NewsDetailViewModelTests: XCTestCase {
    var viewModel: NewsDetailViewModel!

    override func setUp() {
        super.setUp()
        viewModel = NewsDetailViewModel(newsId: 1)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
}
