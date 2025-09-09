//
//  Container.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/9/25.
//

import Foundation
import Domain
import Service

enum Scope {
    case singleton
    case unique
}

final class Container {
    
    static let shared = Container()
    
    private var dependencies: [String: Any] = [:]
    private var factories: [String: () -> Any] = [:]
    private var scopes: [String: Scope] = [:]
    private var mockFactories: [String: () -> Any] = [:]
    
    private init() {
        setupDefaults()
    }
    
    private func setupDefaults() {
        register(Repository.self, scope: .singleton) { APIService() }
    }
    
    // MARK: - Registration
    func register<T>(_ type: T.Type, scope: Scope = .singleton, factory: @escaping () -> T) {
        let key = String(describing: type)
        factories[key] = factory
        scopes[key] = scope
        
        // Clear existing singleton if re-registering
        if scope == .singleton {
            dependencies.removeValue(forKey: key)
        }
    }
    
    func onMock<T>(_ type: T.Type, factory: @escaping () -> T) -> Container {
        let key = String(describing: type)
        mockFactories[key] = factory
        
        // Clear existing singleton when mock is registered
        dependencies.removeValue(forKey: key)
        
        return self
    }
    
    // MARK: - Resolution
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        let scope = scopes[key] ?? .singleton
        
        // Check for mock first
        if let mockFactory = mockFactories[key] {
            switch scope {
            case .singleton:
                if let existing = dependencies[key] as? T {
                    return existing
                } else {
                    let instance = mockFactory() as! T
                    dependencies[key] = instance
                    return instance
                }
            case .unique:
                return mockFactory() as! T
            }
        }
        
        // Use regular factory
        guard let factory = factories[key] else {
            fatalError("No factory registered for \(type)")
        }
        
        switch scope {
        case .singleton:
            if let existing = dependencies[key] as? T {
                return existing
            } else {
                let instance = factory() as! T
                dependencies[key] = instance
                return instance
            }
        case .unique:
            return factory() as! T
        }
    }
    
    // MARK: - Context Detection & Convenience
    private var isPreviewOrTest: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" ||
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil ||
        NSClassFromString("XCTest") != nil
    }
    
    var repository: Repository {
        // Auto-setup mock in preview/test context
        if isPreviewOrTest && mockFactories[String(describing: Repository.self)] == nil {
            _ = onMock(Repository.self) { MockRepository() }
        }
        return resolve(Repository.self)
    }
    
    // MARK: - Utilities
    func clearMocks() {
        mockFactories.removeAll()
        dependencies.removeAll()
    }
}
