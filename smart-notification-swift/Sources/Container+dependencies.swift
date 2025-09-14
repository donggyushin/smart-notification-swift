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
        .onPreview {
            MockRepository()
        }
        .shared
    }
    
    var cache: Factory<CacheRepository> {
        self {
            SwiftDataService()
        }
        .onPreview {
            MockCacheRepository()
        }
        .shared
    }
}
