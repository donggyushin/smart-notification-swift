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
}
