//
//  Injected.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/10/25.
//

import Foundation

@propertyWrapper
public struct Injected<T> {
    private let keyPath: KeyPath<Container, T>
    
    public var wrappedValue: T {
        Container.shared[keyPath: keyPath]
    }
    
    public init(_ keyPath: KeyPath<Container, T>) {
        self.keyPath = keyPath
    }
}
