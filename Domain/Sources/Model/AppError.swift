//
//  AppError.swift
//  Domain
//
//  Created by 신동규 on 9/18/25.
//

import Foundation

public enum AppError: Error {
    case decode
    case custom(String)
    case unknown
}
