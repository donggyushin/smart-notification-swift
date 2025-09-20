//
//  AppTabView.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/20/25.
//

import SwiftUI
import ComposableArchitecture

struct AppTabView: View {
    var body: some View {
        TabView {
            NewsListView(store: .init(initialState: NewsListFeature.State()) {
                NewsListFeature()
            })
            .tabItem {
                Image(systemName: "newspaper")
                Text("News")
            }
            
            SavedNewsListView(model: .init())
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Saved")
                }
        }
    }
}
