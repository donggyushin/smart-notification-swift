//
//  RepositoryImpl.swift
//  Service
//
//  Created by 신동규 on 9/20/25.
//

import Foundation
import Domain

public final class RepositoryImpl: Repository {
    
    let apiService = APIService()
    
    public func postDevice(device_uuid: String, fcm_token: String) async throws {
        try await apiService.postDevice(device_uuid: device_uuid, fcm_token: fcm_token)
    }
    
    public func getNewsFeed(cursor_id: Int?) async throws -> NewsResponse {
        try await apiService.getNewsFeed(cursor_id: cursor_id)
    }
    
    public func getNews(id: Int) async throws -> NewsEntity {
        try await apiService.getNews(id: id)
    }
    
    public init() { }
}
