import Foundation
import XCTest
@testable import Service

final class SmartNotificationSwiftTests: XCTestCase {

    func test_parseDate_withISO8601FractionalSeconds() {
        let dateString = "2024-09-18T10:30:45.123Z"
        let result = parseDate(from: dateString)

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let expected = formatter.date(from: dateString)!

        XCTAssertEqual(result, expected)
    }

    func test_parseDate_withBasicISO8601() {
        let dateString = "2024-09-18T10:30:45Z"
        let result = parseDate(from: dateString)

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        let expected = formatter.date(from: dateString)!

        XCTAssertEqual(result, expected)
    }

    func test_parseDate_withInvalidDate_returnsFallback() {
        let dateString = "invalid-date-string"
        let result = parseDate(from: dateString)

        // Should return current date as fallback
        let now = Date()
        XCTAssertLessThan(abs(result.timeIntervalSince(now)), 1.0) // Within 1 second
    }
}
