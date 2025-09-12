//
//  Container+dependencies.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/10/25.
//

import Domain
import Service
import Container

extension Container {
    var repository: Factory<Repository> {
        self {
            APIService()
        }
        .shared
        .onPreview {
            MockRepository()
        }
    }
}
