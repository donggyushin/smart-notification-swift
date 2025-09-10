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
    private var isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    private var isTest: Bool = {
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
    private var sharedObjectStorage: [String: Any] = [:]
    
    private init() {}
    
    var repository: Repository {
        resolve(scope: .shared) {
            APIService()
        } mockFactory: {
            MockRepository()
        }
    }
}

private final class WeakWrapper {
    weak var value: AnyObject?
    
    init(value: AnyObject? = nil) {
        self.value = value
    }
}

extension Container {
    enum Scope {
        case unique
        case shared
    }
}

extension Container {
    private func resolve<T: Any>(scope: Scope, factory: @escaping () -> T, mockFactory: (() -> T)? = nil) -> T {
        
        if (isPreview || isTest) && mockFactory != nil {
            return mockFactory!()
        }
        
        if scope == .unique {
            return factory()
        } else {
            if let shared = sharedObjectStorage["\(T.self)"] as? T {
                return shared
            } else {
                let newInstance = factory()
                sharedObjectStorage["\(T.self)"] = newInstance
                return newInstance
            }
        }
    }
}
