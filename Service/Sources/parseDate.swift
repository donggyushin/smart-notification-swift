//
//  parseDate.swift
//  Service
//
//  Created by 신동규 on 9/14/25.
//

import Foundation

func parseDate(from dateString: String) -> Date {
    // Try ISO8601 with fractional seconds and timezone
    let iso8601Formatter = ISO8601DateFormatter()
    iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

    if let date = iso8601Formatter.date(from: dateString) {
        return date
    }

    // Fallback to basic ISO8601 format
    iso8601Formatter.formatOptions = [.withInternetDateTime]
    if let date = iso8601Formatter.date(from: dateString) {
        return date
    }

    // Last resort fallback
    return Date()
}
