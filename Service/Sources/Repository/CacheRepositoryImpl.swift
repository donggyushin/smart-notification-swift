//
//  CacheRepositoryImpl.swift
//  Service
//
//  Created by 신동규 on 9/20/25.
//

import Foundation
import Domain

public final class CacheRepositoryImpl: CacheRepository {
    
    let swiftDataService = SwiftDataService()
    
    public func getNews() -> [NewsEntity] {
        swiftDataService.getNews()
    }
    
    public func saveNews(_ news: [NewsEntity]) {
        swiftDataService.saveNews(news)
    }
    
    public func clearAllNewsData() {
        swiftDataService.clearAllNewsData()
    }
    
    public init() { }
}
