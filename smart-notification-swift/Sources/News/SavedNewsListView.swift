//
//  SavedNewsListView.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/20/25.
//

import SwiftUI
import ComposableArchitecture
import Domain

struct SavedNewsListView: View {
    
    let store: StoreOf<SavedNewsListFeature>
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        List {
            ForEach(store.news, id: \.id) { newsItem in
                NewsItemRow(newsItem: newsItem) { _ in
                    store.send(.saveNews(newsItem))
                }
                .onTapGesture {
                    navigationManager.push(.news(newsItem.id))
                }
                .onAppear {
                    if newsItem.id == store.news.last?.id {
                        store.send(.fetchSavedNews)
                    }
                }
            }
            
            if store.loading && store.news.isEmpty {
                HStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.2)
                    Spacer()
                }
                .padding()
            }
        }
        .scrollIndicators(.never)
        .refreshable {
            store.send(.reload)
        }
        .task {
            store.send(.fetchSavedNews)
        }
    }
}

#Preview {
    SavedNewsListView(store: .init(initialState: SavedNewsListFeature.State(), reducer: {
        SavedNewsListFeature()
    }))
}
