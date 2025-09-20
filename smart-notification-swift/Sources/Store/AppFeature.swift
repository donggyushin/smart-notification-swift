//
//  AppFeature.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/20/25.
//

import Foundation
import ComposableArchitecture
import Domain
import Container

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var newsList = NewsListFeature.State()
        var savedNewsList = SavedNewsListFeature.State()
    }
    
    enum Action {
        case newsList(NewsListFeature.Action)
        case savedNewsList(SavedNewsListFeature.Action)
        case syncData(NewsEntity)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.newsList, action: \.newsList) {
            NewsListFeature()
        }
        
        Scope(state: \.savedNewsList, action: \.savedNewsList) {
            SavedNewsListFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .newsList(.saveNewsResponse(let news)):
                return .run { send in
                    await send(.syncData(news))
                }
            case .savedNewsList(.saveNewsResponse(let news)):
                return .run { send in
                    await send(.syncData(news))
                }
            case .syncData(let news):
                
                if let index = state.newsList.news.firstIndex(where: { $0.id == news.id }) {
                    state.newsList.news[index] = news
                }
                
                if let index = state.savedNewsList.news.firstIndex(where: { $0.id == news.id }) {
                    state.savedNewsList.news[index] = news
                } else if news.save {
                    state.savedNewsList.news.insert(news, at: 0)
                }
                
                return .none
            default:
                return .none
            }
        }
        
    }
}
