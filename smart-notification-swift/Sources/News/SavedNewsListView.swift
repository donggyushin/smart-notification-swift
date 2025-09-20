//
//  SavedNewsListView.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/20/25.
//

import SwiftUI

struct SavedNewsListView: View {
    
    @StateObject var model: SavedNewsListViewModel
    
    var body: some View {
        List {
            ForEach(model.news, id: \.id) { newsItem in
                NewsItemRow(newsItem: newsItem)
                    .onTapGesture {
                        coordinator?.push(.news(newsItem.id))
                    }
                    .onAppear {
                        if newsItem.id == model.news.last?.id {
                            Task {
                                try? await model.fetchSavedNews()
                            }
                        }
                    }
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
        .scrollIndicators(.never)
        .navigationTitle("Saved News")
        .refreshable {
            try? await model.refresh()
        }
        .task {
            if model.news.isEmpty {
                try? await model.fetchSavedNews()
            }
        }
    }
}

#Preview {
    SavedNewsListView(model: .init())
        .preferredColorScheme(.dark)
}
