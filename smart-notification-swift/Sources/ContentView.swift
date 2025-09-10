import SwiftUI

public struct ContentView: View {
    
    @State private var path: [NavigationPath] = []
    
    public init() {}

    public var body: some View {
        NavigationStack(path: $path) {
            NewsListView(model: .init())
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
