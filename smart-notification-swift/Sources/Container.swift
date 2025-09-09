//
//  Container.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/9/25.
//

import Foundation
import Domain
import Service

final class Container {
    
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
    
    static let shared = Container()
    
    private init() { }
    
    var repository: Repository {
        if isPreview {
            return MockRepository()
        }
        return APIService()
    }
}
