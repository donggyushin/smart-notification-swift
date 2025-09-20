//
//  Container+dependencies.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/10/25.
//

import Domain
import Service
import Container

// Register repositories
extension Container {
    var repository: Factory<Repository> {
        self {
            RepositoryImpl()
        }
        .onPreview {
            MockRepository()
        }
        .shared
    }
    
    var cache: Factory<CacheRepository> {
        self {
            CacheRepositoryImpl()
        }
        .onPreview {
            MockCacheRepository()
        }
        .shared
    }
}

// Register UseCases
extension Container {
    var saveFeedUseCase: Factory<SaveFeedUseCase> {
        self {
            SaveFeedUseCase(repository: self.repository())
        }
        .shared
    }
}
