# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Swift iOS application that provides smart notifications for stock market news. The app analyzes news articles using AI for their potential impact on the US stock market and presents them with impact scores and relevant stock tickers.

## Build System & Commands

This project uses **Tuist** for project generation and dependency management:

```bash
# Generate and open the Xcode project
tuist generate

# Clean the project
tuist clean

# Build the project
xcodebuild -workspace smart-notification-swift.xcworkspace -scheme smart-notification-swift -destination 'platform=iOS Simulator,name=iPhone 15'

# Run tests
xcodebuild test -workspace smart-notification-swift.xcworkspace -scheme smart-notification-swift -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Architecture

### Modular Architecture
The project follows a clean, modular architecture with clear separation of concerns:

- **App Module** (`smart-notification-swift`): Main iOS app target containing UI, ViewModels, and dependency injection
- **Domain**: Core business logic with entities (`NewsEntity`, `NewsResponse`) and repository protocols (`Repository`, `CacheRepository`)
- **Service**: API implementation, SwiftData caching, DTOs, and mock data for testing/previews
- **ThirdPartyLibrary**: External dependencies wrapper (Alamofire)

### Dependency Flow
```
App → Service → Domain → ThirdPartyLibrary
```

### Key Architectural Patterns

**Repository Pattern**:
- `Repository` protocol in Domain defines API data access interface
- `CacheRepository` protocol in Domain defines local storage interface
- `APIService` in Service implements real API calls
- `SwiftDataService` in Service implements local caching with SwiftData
- `MockRepository` and `MockCacheRepository` in Service provide test/preview data
- Automatic selection via `Container` based on environment (preview/test vs production)

**Dependency Injection**:
- Custom `@Injected` property wrapper for clean dependency injection
- `Container` singleton manages dependency resolution and environment detection
- Usage: `@Injected(\.repository) var repository` and `@Injected(\.cache) var cache`

**MVVM Pattern**:
- SwiftUI Views bind to ObservableObject ViewModels
- ViewModels handle business logic and state management
- Example: `NewsListView` + `NewsListViewModel`

### Project Structure

```
smart-notification-swift/Sources/
├── News/                           # News feature module
├── DependencyInjection/           # DI system (@Injected, Container)
├── Coordinator/                   # Navigation coordination
└── App files (ContentView, App)

Domain/Sources/
├── Repository.swift               # API data access protocol
├── CacheRepository.swift          # Local storage protocol
└── Model/NewsEntity.swift         # Core domain entities

Service/Sources/
├── APIService.swift              # Production API implementation
├── SwiftDataService.swift        # SwiftData local caching implementation
├── MockRepository.swift          # Test/preview API mock data
├── MockCacheRepository.swift     # Test/preview cache mock data
├── APIClient.swift               # HTTP client wrapper
└── DTO/
    ├── NewsDTO.swift             # API data transfer objects
    └── NewsLocalDTO.swift        # SwiftData persistence model
```

### Dependencies

**External Libraries** (managed via Tuist/Package.swift):
- Firebase (Auth, Messaging) - Push notifications and authentication
- Alamofire - HTTP networking
- SwiftData - Local data persistence and caching

**Environment Detection**:
The Container automatically detects runtime environment:
- **Preview mode**: Uses MockRepository and MockCacheRepository for SwiftUI previews
- **Test mode**: Uses MockRepository and MockCacheRepository for unit tests
- **Production**: Uses APIService and SwiftDataService for real API calls and local caching

## Key Features

**News Feed**: Displays AI-analyzed news articles with:
- Impact scores (-10 to +10) with color coding
- Relevant stock tickers as badges
- **Local caching with SwiftData** for offline access and instant loading
- Pull-to-refresh and infinite scroll capability
- Tap-to-open functionality for news URLs

**Smart Notifications**: Firebase integration for push notifications about high-impact market news.

**Caching Strategy**:
- `prepareInitialData()` loads cached news instantly (no loading spinner)
- Fresh data is fetched from API and cached for future use
- Clean separation between API data (`NewsEntity`) and persistence layer (`NewsLocalDTO`)

## Development Notes

- SwiftUI with iOS target
- Uses `@StateObject` for ViewModels and `@Published` for reactive properties
- All async operations use Swift's async/await pattern
- Tuist project generation ensures consistent build configuration across team members