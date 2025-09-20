//
//  APIService.swift
//  Service
//
//  Created by 신동규 on 9/9/25.
//

import Foundation
import Domain

public final class APIService: Repository {
    
    private let apiClient = APIClient(baseURL: "https://smart-notification-fastapi-production.up.railway.app")
    
    public init() { }
    
    public func postDevice(device_uuid: String, fcm_token: String) async throws {
        let _: EmptyDTO = try await apiClient.request(
            "/devices",
            method: .post,
            parameters: [
                "device_uuid": device_uuid,
                "fcm_token": fcm_token
            ]
        )
    }
    
    public func getNewsFeed(cursor_id: Int?) async throws -> NewsResponse {
        var parameters: [String: Any] = [:]
        if let cursor_id = cursor_id {
            parameters["cursor_id"] = cursor_id
        }
        
        let response: NewsResponseDTO = try await apiClient.request(
            "/news/feed",
            method: .get,
            parameters: parameters
        )
        return response.toDomain()
    }
    
    public func getNews(id: Int) async throws -> NewsEntity {
        let url = "/news/\(id)"
        let response: NewsDTO = try await apiClient.request(url)
        return response.toDomain()
    }
}
