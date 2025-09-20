//
//  CacheRepository.swift
//  Domain
//
//  Created by 신동규 on 9/14/25.
//

import Foundation

public protocol CacheRepository {
    func getNews() -> [NewsEntity]
    func saveNews(_ news: [NewsEntity])
    func clearAllNewsData()
    func saveSavedNews(_ news: [NewsEntity])
    func getSavedNews() -> [NewsEntity]
    func clearSavedNews()
}
