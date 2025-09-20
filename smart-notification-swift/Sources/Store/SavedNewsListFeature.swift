//
//  SavedNewsListFeature.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/20/25.
//

import Foundation
import ComposableArchitecture
import Domain
import Container

@Reducer
struct SavedNewsListFeature {
    @ObservableState
    struct State: Equatable {
        var news: [NewsEntity] = []
        var loading = false
        var next_cursor_id: Int?
        var has_more: Bool = true
    }
    
    enum Action {
        case reload
        case reloadResponse(NewsResponse)
        
        case fetchSavedNews
        case fetchSavedNewsResponse(NewsResponse)
        
        case saveNews(NewsEntity)
        case saveNewsResponse(NewsEntity)
    }
    
    @Injected(\.repository) private var repository
    @Injected(\.saveFeedUseCase) private var saveFeedUseCase
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
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
                
            case .fetchSavedNews:
                guard state.loading == false, state.has_more else { return .none }
                state.loading = true
                return .run { [cursorId = state.next_cursor_id] send in
                    let response = try await repository.getSavedNewsFeed(cursor_id: cursorId)
                    await send(.fetchSavedNewsResponse(response))
                }
            case .fetchSavedNewsResponse(let response):
                state.loading = false
                state.next_cursor_id = response.next_cursor_id
                state.has_more = response.has_more
                state.news.append(contentsOf: response.items)
                return .none
                
            case .saveNews(let news):
                guard state.loading == false else { return .none }
                state.loading = true
                return .run { send in
                    let response = try await saveFeedUseCase.execute(news: news)
                    await send(.saveNewsResponse(response))
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
