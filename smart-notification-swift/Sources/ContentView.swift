import SwiftUI

public struct ContentView: View {
    
    @State private var path: [NavigationPath] = []
    
    public init() {}

    public var body: some View {
        NavigationStack(path: $path) {
            AppTabView()
                .navigationDestination(for: NavigationPath.self) { path in
                    switch path {
                    case .news(let id):
                        NewsDetailView(model: .init(newsId: id))
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
