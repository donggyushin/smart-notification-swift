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

struct NewsItemRow: View {
    let newsItem: NewsEntity
    let onSave: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(newsItem.title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Spacer()
                Button(action: {
                    onSave(newsItem.id)
                }) {
                    Image(systemName: newsItem.save ? "bookmark.fill" : "bookmark")
                        .foregroundColor(newsItem.save ? .yellow : .gray)
                        .font(.title3)
                }
                .buttonStyle(PlainButtonStyle())
                ScoreView(score: newsItem.score)
            }
            
            Text(newsItem.summarize)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            HStack {
                if !newsItem.tickers.isEmpty {
                    HStack {
                        ForEach(newsItem.tickers.prefix(3), id: \.self) { ticker in
                            Text(ticker)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                        if newsItem.tickers.count > 3 {
                            Text("+\(newsItem.tickers.count - 3)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Spacer()
                Text(newsItem.published_date, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
