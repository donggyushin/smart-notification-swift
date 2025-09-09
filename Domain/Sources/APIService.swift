//
//  APIService.swift
//  Domain
//
//  Created by 신동규 on 9/9/25.
//

public protocol APIService {
    func postDevice(device_uuid: String, fcm_token: String) async throws
    func getNewsFeed(cursor_id: Int?) async throws -> NewsResponse
}
