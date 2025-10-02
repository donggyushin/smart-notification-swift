//
//  NavigationManager.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/10/25.
//

import SwiftUI

final class NavigationManager: ObservableObject {
    @Published var path: [NavigationPath] = []
    
    func push(_ path: NavigationPath) {
        self.path.append(path)
    }
    
    func pop() {
        guard path.isEmpty == false else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        guard path.isEmpty == false else { return }
        path.removeAll()
    }
}
