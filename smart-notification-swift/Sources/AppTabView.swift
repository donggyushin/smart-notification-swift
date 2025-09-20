//
//  AppTabView.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/20/25.
//

import SwiftUI
import ComposableArchitecture

struct AppTabView: View {

    let store: StoreOf<AppFeature>
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NewsListView(store: store.scope(state: \.newsList, action: \.newsList) )
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("News")
                }
                .tag(0)

            SavedNewsListView(store: store.scope(state: \.savedNewsList, action: \.savedNewsList))
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Saved")
                }
                .tag(1)
        }
        .navigationTitle(selectedTab == 0 ? "Market News" : "Saved News")
    }
}
