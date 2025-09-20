//
//  StoreTests.swift
//  smart-notification-swiftTests
//
//  Created by 신동규 on 9/20/25.
//

@testable import smart_notification_swift
import XCTest
import ComposableArchitecture

final class StoreTests: XCTestCase {
    var store: StoreOf<AppFeature>!
    
    override func setUp() {
        super.setUp()
        store = .init(initialState: AppFeature.State(), reducer: {
            AppFeature()
        })
    }

    override func tearDown() {
        store = nil
        super.tearDown()
    }
    
    func test_store_sync_data() async throws {
        let newsList = await store.scope(state: \.newsList, action: \.newsList)
        let savedNewsList = await store.scope(state: \.savedNewsList, action: \.savedNewsList)
        
        await newsList.send(.fetchNews)
        
        // There is loading even when using MockRepository
        try await Task.sleep(for: .seconds(1.5))
        // First cell's save is always false
        let firstMatchedNews = await newsList.news.first!
        XCTAssertFalse(firstMatchedNews.save)
        
        // Tap first cell's save button
        await newsList.send(.saveNews(firstMatchedNews))
        
        try await Task.sleep(for: .seconds(0.5))
        
        // Then newsList's first cell's save is true
        let result1 = await newsList.news.first!.save
        XCTAssertTrue(result1)
        
        // savedNewsList has cell even though haven't fetch data from server
        let savedFirstMatchedCell = await savedNewsList.news.first!
        
        // Then tap save button from savedNewsList
        await savedNewsList.send(.saveNews(savedFirstMatchedCell))
        try await Task.sleep(for: .seconds(0.5))
        
        // Then newsList's first cell's save is false
        let result2 = await newsList.news.first!.save
        XCTAssertFalse(result2)
    }
}
