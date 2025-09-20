//
//  Repository.swift
//  Domain
//
//  Created by 신동규 on 9/9/25.
//

public protocol Repository {
    func postDevice(device_uuid: String, fcm_token: String) async throws
    func getNewsFeed(cursor_id: Int?) async throws -> NewsResponse
    func getNews(id: Int) async throws -> NewsEntity
    func save(news: NewsEntity, save: Bool) async throws -> NewsEntity
    func getSavedNewsFeed(cursor_id: Int?) async throws -> NewsResponse
}
