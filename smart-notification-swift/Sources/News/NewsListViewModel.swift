//
//  NewsListViewModel.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/10/25.
//

import Foundation
import SwiftUI
import Domain
import Combine
import Container

final class NewsListViewModel: ObservableObject {
    
    @Injected(\.repository) var repository
    @Injected(\.cache) var cache
    
    @Published var news: [NewsEntity] = []
    @Published var loading = false
    private var next_cursor_id: Int?
    private var has_more = true
    
    @MainActor
    func prepareInitialData() {
        self.news = cache.getNews()
    }
    
    @MainActor
    func reload() async throws {
        guard loading == false else { return }
        loading = true
        defer { loading = false }
        let response = try await repository.getNewsFeed(cursor_id: nil)
        news = response.items
        next_cursor_id = response.next_cursor_id
        has_more = response.has_more
    }
    
    @MainActor
    func fetchNews() async throws {
        guard has_more else { return }
        guard loading == false else { return }
        loading = true
        defer { loading = false }
        let response = try await repository.getNewsFeed(cursor_id: next_cursor_id)
        
        if self.news.isEmpty {
            cache.saveNews(response.items)
        }
        
        news.append(contentsOf: response.items)
        next_cursor_id = response.next_cursor_id
        has_more = response.has_more
    }
}
