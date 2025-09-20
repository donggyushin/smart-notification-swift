//
//  SaveNewsUseCase.swift
//  Domain
//
//  Created by 신동규 on 9/20/25.
//

import Foundation

public final class SaveNewsUseCase {
    let repository: Repository
    let cache: CacheRepository
    
    public init(repository: Repository, cache: CacheRepository) {
        self.repository = repository
        self.cache = cache
    }
    
    public func execute(news: NewsEntity) async throws -> NewsEntity {
        try await repository.save(news: news, save: !news.save)
    }
}
