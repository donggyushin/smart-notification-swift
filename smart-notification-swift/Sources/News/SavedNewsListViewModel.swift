//
//  SavedNewsListViewModel.swift
//  ThirdPartyLibrary
//
//  Created by 신동규 on 9/20/25.
//

import Foundation
import Combine
import Domain
import Container

final class SavedNewsListViewModel: ObservableObject {
    @Injected(\.saveFeedUseCase) var saveFeedUseCase
    @Injected(\.repository) var repository
    
    @Published var news: [NewsEntity] = []
    @Published var loading = false
    
    private var cursor_id: Int?
    private var has_more: Bool = true
    
    @MainActor
    func refresh() async throws {
        guard loading == false else { return }
        loading = true
        defer { loading = false }
        
        let response = try await repository.getSavedNewsFeed(cursor_id: cursor_id)
        has_more = response.has_more
        cursor_id = response.next_cursor_id
        news = response.items
    }
    
    @MainActor
    func fetchSavedNews() async throws {
        guard has_more == true else { return }
        guard loading == false else { return }
        loading = true
        defer { loading = false }
        
        let response = try await repository.getSavedNewsFeed(cursor_id: cursor_id)
        has_more = response.has_more
        cursor_id = response.next_cursor_id
        news.append(contentsOf: response.items)
    }
    
    @MainActor
    func saveNews(_ news: NewsEntity) async throws {
        let news = try await saveFeedUseCase.execute(news: news)
        guard let index = self.news.firstIndex(where: { $0.id == news.id }) else { return }
        self.news[index] = news
    }
}
