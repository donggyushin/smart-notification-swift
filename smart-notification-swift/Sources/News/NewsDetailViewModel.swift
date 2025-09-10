//
//  NewsDetailViewModel.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/10/25.
//

import Foundation
import Combine
import Container
import Domain

final class NewsDetailViewModel: ObservableObject {
    @Injected(\.repository) private var repository
    
    @Published var news: NewsEntity?
    @Published var loading = false
    
    let newsId: Int
    init(newsId: Int) {
        self.newsId = newsId
    }
    
    @MainActor
    func fetchNewsData() async throws {
        guard loading == false else { return }
        loading = true
        defer { loading = false }
        news = try await repository.getNews(id: newsId)
    }
}
