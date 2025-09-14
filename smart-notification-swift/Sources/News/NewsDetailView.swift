//
//  NewsDetailView.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/10/25.
//

import SwiftUI
import Domain

struct NewsDetailView: View {
    
    @StateObject var model: NewsDetailViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                if model.loading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading news...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let news = model.news {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                ScoreView(score: news.score)
                                Spacer()
                                Text(news.published_date, format: .dateTime.year().month().day().hour().minute())
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(news.title)
                                .font(.title2.bold())
                                .multilineTextAlignment(.leading)
                        }
                        
                        if !news.tickers.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Related Tickers")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                                    ForEach(news.tickers, id: \.self) { ticker in
                                        Text(ticker)
                                            .font(.caption.bold())
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.blue.opacity(0.1))
                                            .foregroundColor(.blue)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Summary")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(news.summarize)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineSpacing(4)
                        }
                        
                        if let url = news.url {
                            Button(action: {
                                UIApplication.shared.open(url)
                            }) {
                                HStack {
                                    Image(systemName: "safari")
                                    Text("Read Full Article")
                                        .fontWeight(.medium)
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                }
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding()
                } else {
                    VStack {
                        Spacer()
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        Text("Failed to load news")
                            .font(.title3)
                            .padding(.top)
                        Text("Please try again later")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("News Detail")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            try? await model.fetchNewsData()
        }
    }
}

#Preview {
    NewsDetailView(model: .init(newsId: 1))
}
