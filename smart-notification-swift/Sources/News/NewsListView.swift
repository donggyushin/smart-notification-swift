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
        List {
            ForEach(store.news, id: \.id) { newsItem in
                NewsItemRow(newsItem: newsItem) { _ in
                    store.send(.saveNews(newsItem))
                }
                .onTapGesture {
                    coordinator?.push(.news(newsItem.id))
                }
                .onAppear {
                    if newsItem.id == store.news.last?.id {
                        store.send(.fetchNews)
                    }
                }
            }
            
            if store.loading {
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
            if store.news.isEmpty {
                store.send(.prepareInitialData)
                store.send(.fetchNews)
            }
        }
    }
}

#Preview {
    NewsListView(store: .init(initialState: NewsListFeature.State(), reducer: {
        NewsListFeature()
    }))
    .preferredColorScheme(.dark)
}
