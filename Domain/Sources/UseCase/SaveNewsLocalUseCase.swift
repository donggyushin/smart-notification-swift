//
//  SaveNewsLocalUseCase.swift
//  Domain
//
//  Created by 신동규 on 9/21/25.
//

import Foundation

public final class SaveNewsLocalUseCase {
    let cache: CacheRepository
    
    public init(cache: CacheRepository) {
        self.cache = cache
    }
    
    public func execute(_ news: [NewsEntity], onlySavedNews: Bool) {
        
        if onlySavedNews {
            cache.clearSavedNews()
            cache.saveSavedNews(news)
        } else {
            cache.clearAllNewsData()
            cache.saveNews(news)
        }
    }
}
