//
//  NewsListView.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/10/25.
//

import SwiftUI
import Domain

struct NewsListView: View {
    
    @StateObject var model: NewsListViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.news, id: \.id) { newsItem in
                    NewsItemRow(newsItem: newsItem)
                }
                
                if model.loading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.2)
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Market News")
            .refreshable {
                try? await model.fetchNews()
            }
            .task {
                if model.news.isEmpty {
                    try? await model.fetchNews()
                }
            }
        }
    }
}

struct NewsItemRow: View {
    let newsItem: NewsEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(newsItem.title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Spacer()
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

struct ScoreView: View {
    let score: Int
    
    var body: some View {
        Text("\(score > 0 ? "+" : "")\(score)")
            .font(.caption.bold())
            .foregroundColor(scoreColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(scoreColor.opacity(0.1))
            .cornerRadius(8)
    }
    
    private var scoreColor: Color {
        if score > 0 {
            return .green
        } else if score < 0 {
            return .red
        } else {
            return .gray
        }
    }
}

#Preview {
    NewsListView(model: .init())
        .preferredColorScheme(.dark)
}
