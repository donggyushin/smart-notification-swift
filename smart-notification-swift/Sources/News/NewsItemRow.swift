//
//  NewsItemRow.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/20/25.
//

import SwiftUI
import Domain

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
