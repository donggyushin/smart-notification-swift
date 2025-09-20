//
//  SaveNewsUseCase.swift
//  Domain
//
//  Created by 신동규 on 9/20/25.
//

import Foundation

public final class SaveNewsUseCase {
    let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func execute(news: NewsEntity) async throws -> NewsEntity {
        try await repository.save(news: news, save: !news.save)
    }
}
