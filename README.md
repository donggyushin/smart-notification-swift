# Smart Notification iOS App

A personal iOS application for receiving intelligent stock market news notifications with AI-powered impact analysis.

## Why I Built This

This app was built **entirely for personal use**. I'm not planning to publish it to the App Store, and it intentionally lacks authentication logic because it's designed specifically for my own needs.

The real intelligence happens on the backend - a Python FastAPI server ([smart-notification-fastapi](https://github.com/donggyushin/smart-notification-fastapi)) that:
- Searches for news with potentially high impact on the US stock market
- Analyzes articles using AI to determine market impact
- Provides summaries and impact scores
- Sends push notifications for significant news

This iOS app is simply a **convenient interface** to consume that service. It's intentionally simple and lightweight - just receive push notifications from the server and display the analyzed data.

## The Real Value: Architecture & Experience

While the app itself is simple, **this project represents years of real-world iOS development experience**. Having worked professionally as an iOS developer for many years, I've learned what matters most in production codebases:

- When to focus on architectural perfection vs. productivity
- How to make projects easy to develop and maintain
- Finding the right balance between over-engineering and under-engineering

This app's architecture is the **result of that learning** - a practical, clean, and maintainable approach that I've refined through real-world experience.

## Architecture Highlights

### Clean Modular Architecture
```
App → Service → Domain → ThirdPartyLibrary
```

**Domain**: Core business logic and entities
- `NewsEntity`, `NewsResponse` models
- `Repository` protocol defining data access interface

**Service**: API implementation and data layer
- `APIService` for production API calls
- `MockRepository` for development/testing
- DTOs and networking logic

**App**: UI, ViewModels, and dependency injection
- SwiftUI views with MVVM pattern
- Custom dependency injection system
- Navigation coordination

### Beautiful Dependency Injection

The crown jewel of this architecture is the **elegant dependency injection system**:

**Container** (`smart-notification-swift/Sources/DependencyInjection/Container.swift`):
```swift
final class Container {
    static let shared = Container()
    
    // Automatic environment detection
    public var isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    public var isTest: Bool = // ... test detection logic
    
    var repository: Repository {
        if isPreview || isTest {
            return repositoryMock  // Mock data for development
        } else {
            return repositoryImpl  // Real API for production
        }
    }
}
```

**@Injected Property Wrapper** (`smart-notification-swift/Sources/DependencyInjection/Injected.swift`):
```swift
@propertyWrapper
struct Injected<T> {
    private let keyPath: KeyPath<Container, T>
    
    var wrappedValue: T {
        Container.shared[keyPath: keyPath]
    }
    
    init(_ keyPath: KeyPath<Container, T>) {
        self.keyPath = keyPath
    }
}
```

**Usage** - Clean, declarative, and type-safe:
```swift
final class NewsListViewModel: ObservableObject {
    @Injected(\.repository) var repository  // ✨ That's it!
    
    func fetchNews() async throws {
        let response = try await repository.getNewsFeed(cursor_id: nil)
        // ...
    }
}
```

### Why This Approach Works

1. **Environment Awareness**: Automatically uses mock data in SwiftUI previews and tests, real API in production
2. **Type Safety**: Compile-time checking with KeyPath-based injection
3. **Zero Boilerplate**: No manual dependency registration or complex setup
4. **Easy Testing**: Seamless mock injection without code changes
5. **Clean Syntax**: Developers can focus on business logic, not infrastructure

## Key Features

- **Smart News Feed**: AI-analyzed market news with impact scores (-10 to +10)
- **Stock Tickers**: Relevant stocks affected by each news item
- **Push Notifications**: Instant alerts for high-impact market events
- **Clean UI**: Simple, focused interface built with SwiftUI
- **Pull-to-Refresh**: Easy data updates with native iOS patterns

## Technology Stack

- **iOS**: SwiftUI, Combine, async/await
- **Architecture**: MVVM with Repository pattern
- **DI**: Custom property wrapper system
- **Networking**: Alamofire
- **Push Notifications**: Firebase Messaging
- **Build System**: Tuist for project generation

## Getting Started

```bash
# Generate the Xcode project
tuist generate

# Open and run
open smart-notification-swift.xcworkspace
```

## Project Philosophy

This project embodies my philosophy of **practical architecture**:

- **Simple when possible, complex when necessary**
- **Developer experience matters as much as code quality**
- **Architecture should enable, not hinder productivity**
- **Real-world experience trumps theoretical perfection**

The result is a codebase that's both maintainable and enjoyable to work with - something I've learned is crucial for long-term project success.

---

*This is a personal project showcasing practical iOS architecture patterns learned through years of professional development experience.*