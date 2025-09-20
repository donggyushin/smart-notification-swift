//
//  NewsListFeature.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/20/25.
//

import Foundation
import ComposableArchitecture
import Domain
import Container

@Reducer
struct NewsListFeature {
    @ObservableState
    struct State: Equatable {
        var news: [NewsEntity] = []
        var loading = false
        var next_cursor_id: Int?
        var has_more = true
        var isFirstFetching = true
    }
    
    enum Action {
        case fetchNews
        case fetchNewsResponse(NewsResponse)
        
        case reload
        case reloadResponse(NewsResponse)
        
        case saveCache
        
        case prepareInitialData
        
        case saveNews(NewsEntity)
        case saveNewsResponse(NewsEntity)
    }
    
    @Injected(\.repository) private var repository
    @Injected(\.cache) var cache
    @Injected(\.saveFeedUseCase) var saveFeedUseCase
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchNews:
                guard state.loading == false, state.has_more else { return .none }
                state.loading = true
                return .run { [cursorId = state.next_cursor_id] send in
                    await send(.fetchNewsResponse(try await repository.getNewsFeed(cursor_id: cursorId)))
                }
            case .fetchNewsResponse(let response):
                state.loading = false
                state.next_cursor_id = response.next_cursor_id
                state.has_more = response.has_more
                if state.isFirstFetching {
                    state.news = response.items
                } else {
                    state.news.append(contentsOf: response.items)
                }
                state.isFirstFetching = false 
                return .none
                
            case .reload:
                guard state.loading == false else { return .none }
                state.loading = true
                return .run { send in
                    await send(.reloadResponse(try await repository.getNewsFeed(cursor_id: nil)))
                }
            case .reloadResponse(let response):
                state.loading = false
                state.next_cursor_id = response.next_cursor_id
                state.has_more = response.has_more
                state.news = response.items
                return .none
                
            case .saveCache:
                cache.clearAllNewsData()
                cache.saveNews(state.news)
                return .none
                
            case .prepareInitialData:
                state.news = cache.getNews()
                return .none
                
            case .saveNews(let news):
                guard state.loading == false else { return .none }
                state.loading = true
                return .run { send in
                    await send(.saveNewsResponse(try await saveFeedUseCase.execute(news: news)))
                }
            case .saveNewsResponse(let news):
                state.loading = false
                guard let index = state.news.firstIndex(where: { $0.id == news.id }) else { return .none }
                state.news[index] = news
                return .none
            }
        }
    }
}
