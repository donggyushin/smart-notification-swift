//
//  APIClient.swift
//  Service
//
//  Created by 신동규 on 9/9/25.
//

import Foundation
import Alamofire
import Domain

private struct ErrorResponse: Codable {
    let error: String?
    let message: String?
}

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

        // Use URLEncoding for GET requests (query parameters), JSONEncoding for others
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default

        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers
            )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        // First check for error response structure
                        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            if let error = errorResponse.error {
                                continuation.resume(throwing: AppError.custom(error))
                                return
                            }
                            if let message = errorResponse.message {
                                continuation.resume(throwing: AppError.custom(message))
                                return
                            }
                        }

                        // If no error, decode as expected type
                        let decodedValue = try JSONDecoder().decode(T.self, from: data)
                        continuation.resume(returning: decodedValue)
                    } catch {
                        continuation.resume(throwing: AppError.decode)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
