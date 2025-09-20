//
//  NewsListView.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/10/25.
//

import SwiftUI
import Domain
import ComposableArchitecture

struct NewsListView: View {
    let store: StoreOf<NewsListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                ForEach(store.news, id: \.id) { newsItem in
                    NewsItemRow(newsItem: newsItem) { _ in
                        viewStore.send(.saveNews(newsItem))
                    }
                    .onTapGesture {
                        coordinator?.push(.news(newsItem.id))
                    }
                    .onAppear {
                        if newsItem.id == store.news.last?.id {
                            viewStore.send(.fetchNews)
                        }
                    }
                }
                
                if viewStore.loading {
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
            .navigationTitle("Market News")
            .refreshable {
                viewStore.send(.reload)
                viewStore.send(.saveCache)
            }
            .task {
                if viewStore.news.isEmpty {
                    viewStore.send(.prepareInitialData)
                    viewStore.send(.fetchNews)
                    viewStore.send(.saveCache)
                }
            }
        }
    }
}
