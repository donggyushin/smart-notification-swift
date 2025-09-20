//
//  Container+dependencies.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/10/25.
//

import Domain
import Service
import Container // Library that I made myself

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
    var saveNewsUseCase: Factory<SaveNewsUseCase> {
        self {
            SaveNewsUseCase(repository: self.repository(), cache: self.cache())
        }
        .shared
    }
}
