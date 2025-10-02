import SwiftUI
import ComposableArchitecture

public struct ContentView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    public init() {}

    public var body: some View {
        NavigationStack(path: $navigationManager.path) {
            AppTabView(store: store)
                .navigationDestination(for: NavigationPath.self) { path in
                    switch path {
                    case .news(let id):
                        NewsDetailView(model: .init(newsId: id), store: store)
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
