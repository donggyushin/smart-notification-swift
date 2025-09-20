import SwiftUI
import ComposableArchitecture

public struct ContentView: View {
    
    @State private var path: [NavigationPath] = []
    let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    public init() {}

    public var body: some View {
        NavigationStack(path: $path) {
            AppTabView(store: store)
                .navigationDestination(for: NavigationPath.self) { path in
                    switch path {
                    case .news(let id):
                        NewsDetailView(model: .init(newsId: id), store: store)
                    }
                }
        }
        .onAppear {
            coordinator = .init(path: $path)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
