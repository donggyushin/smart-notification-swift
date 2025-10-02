//
//  DeepLinkManager.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/11/25.
//

import Foundation

func openDeepLink(url: URL) {
    guard url.scheme == "smartnotification" else {
        print("Invalid URL scheme: \(url.scheme ?? "nil")")
        return
    }
    
    let host = url.host
    let pathComponents = url.pathComponents.filter { $0 != "/" }
    
    switch host {
    case "news":
        if pathComponents.count == 1 {
            if let newsId = Int(pathComponents[0]) {
                navigationManagerRef?.push(.news(newsId))
            }
        }
        
    default: break
    }
}
