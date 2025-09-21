# Smart Notification iOS App

A personal iOS application for receiving intelligent stock market news notifications with AI-powered impact analysis.

<img width="1776" height="960" alt="image" src="https://github.com/user-attachments/assets/1ff9a031-012b-4807-a4e0-bf18caceedb5" />

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
- `CacheRepository` protocol defining local storage interface

**Service**: API implementation and data layer
- `APIService` for production API calls
- `MockRepository` for development/testing
- `SwiftDataService` for local caching with SwiftData
- DTOs and networking logic

**App**: UI, ViewModels, and dependency injection
- SwiftUI views with MVVM pattern and **The Composable Architecture (TCA)** for shared state
- Custom dependency injection system
- Navigation coordination

### Beautiful Dependency Injection

The crown jewel of this architecture is the **elegant dependency injection system**:

[**Container**](https://github.com/donggyushin/container)
```swift
extension Container {
    var repository: Factory<Repository> {
        self {
            APIService()
        }
        .onPreview {
            MockRepository()
        }
        .shared
    }

    var cache: Factory<CacheRepository> {
        self {
            SwiftDataService()
        }
        .onPreview {
            MockCacheRepository()
        }
        .shared
    }
}
```

**Usage** - Clean, declarative, and type-safe:
```swift
final class NewsListViewModel: ObservableObject {
    @Injected(\.repository) var repository  // ✨ API access
    @Injected(\.cache) var cache           // ✨ Local caching

    func prepareInitialData() {
        self.news = cache.getNews()  // Instant load from cache
    }

    func fetchNews() async throws {
        let response = try await repository.getNewsFeed(cursor_id: nil)
        cache.saveNews(response.items)  // Cache for offline access
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
- **Local Caching**: SwiftData-powered offline access and instant loading
- **Push Notifications**: Instant alerts for high-impact market events
- **Clean UI**: Simple, focused interface built with SwiftUI
- **Pull-to-Refresh**: Easy data updates with native iOS patterns
- **Advanced State Management**: TCA powers seamless shared state across the app
- **Comprehensive Testing**: Robust test coverage including unit tests, TCA store tests, and UI automation tests

## Technology Stack

- **iOS**: SwiftUI, Combine, async/await
- **Architecture**: MVVM with Repository pattern + **TCA for shared state management**
- **State Management**: The Composable Architecture (TCA) for shared state management, ViewModels for single view state management
- **DI**: Custom property wrapper system
- **Networking**: Alamofire
- **Local Storage**: SwiftData for caching
- **Push Notifications**: Firebase Messaging
- **Build System**: Tuist for project generation
- **Testing**: Comprehensive test suite including TCA TestStore and UITests

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
