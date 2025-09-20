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
    
    var body: some View {
        TabView {
            NewsListView(store: store.scope(state: \.newsList, action: \.newsList) )
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("News")
                }
            
            SavedNewsListView(store: store.scope(state: \.savedNewsList, action: \.savedNewsList))
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Saved")
                }
        }
    }
}
