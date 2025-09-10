//
//  Container+dependencies.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/10/25.
//

import Domain
import Service

extension Container {
    var repository: Repository {
        resolve(scope: .shared) {
            APIService()
        } mockFactory: {
            MockRepository()
        }
    }
}
