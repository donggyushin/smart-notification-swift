//
//  Container.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/10/25.
//

import Foundation
import Domain
import Service

final class Container {
    static let shared = Container()
    
    public var isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    
    public var isTest: Bool = {
        var testing = false
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            testing = true
        }
        if ProcessInfo.processInfo.processName.contains("xctest") {
            testing = true
        }
        return testing
    }()
    
    private init() {}
    
    private let repositoryImpl: Repository = APIService()
    private let repositoryMock: Repository = MockRepository()
    var repository: Repository {
        if isPreview || isTest {
            return repositoryMock
        } else {
            return repositoryImpl
        }
    }
}
