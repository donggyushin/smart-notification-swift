//
//  APIClient.swift
//  Service
//
//  Created by 신동규 on 9/9/25.
//

import Foundation
import Alamofire

public protocol APIClientProtocol {
    func request<T: Codable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?
    ) async throws -> T
}

public class APIClient: APIClientProtocol {
    private let session: Session
    private let baseURL: String
    
    public init(baseURL: String, configuration: URLSessionConfiguration = .default) {
        self.baseURL = baseURL
        self.session = Session(configuration: configuration)
    }
    
    public func request<T: Codable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        let url = baseURL + endpoint
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
