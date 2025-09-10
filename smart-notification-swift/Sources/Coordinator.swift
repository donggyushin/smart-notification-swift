//
//  Coordinator.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/10/25.
//

import SwiftUI

var coordinator: Coordinator?

final class Coordinator {
    @Binding var path: [NavigationPath]
    
    init(path: Binding<[NavigationPath]>) {
        self._path = path
    }
    
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
