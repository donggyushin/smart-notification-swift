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
- **Domain**: Core business logic with entities (`NewsEntity`, `NewsResponse`) and repository protocol
- **Service**: API implementation, DTOs, and mock data for testing/previews
- **ThirdPartyLibrary**: External dependencies wrapper (Alamofire)

### Dependency Flow
```
App → Service → Domain → ThirdPartyLibrary
```

### Key Architectural Patterns

**Repository Pattern**: 
- `Repository` protocol in Domain defines data access interface
- `APIService` in Service implements real API calls
- `MockRepository` in Service provides test/preview data
- Automatic selection via `Container` based on environment (preview/test vs production)

**Dependency Injection**:
- Custom `@Injected` property wrapper for clean dependency injection
- `Container` singleton manages dependency resolution and environment detection
- Usage: `@Injected(\.repository) var repository`

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
├── Repository.swift               # Data access protocol
└── Model/NewsEntity.swift         # Core domain entities

Service/Sources/
├── APIService.swift              # Production API implementation
├── MockRepository.swift          # Test/preview mock data
├── APIClient.swift               # HTTP client wrapper
└── DTO/                          # Data transfer objects
```

### Dependencies

**External Libraries** (managed via Tuist/Package.swift):
- Firebase (Auth, Messaging) - Push notifications and authentication
- Alamofire - HTTP networking

**Environment Detection**:
The Container automatically detects runtime environment:
- **Preview mode**: Uses MockRepository for SwiftUI previews
- **Test mode**: Uses MockRepository for unit tests  
- **Production**: Uses APIService for real API calls

## Key Features

**News Feed**: Displays AI-analyzed news articles with:
- Impact scores (-10 to +10) with color coding
- Relevant stock tickers as badges
- Pull-to-refresh and infinite scroll capability
- Tap-to-open functionality for news URLs

**Smart Notifications**: Firebase integration for push notifications about high-impact market news.

## Development Notes

- SwiftUI with iOS target
- Uses `@StateObject` for ViewModels and `@Published` for reactive properties
- All async operations use Swift's async/await pattern
- Tuist project generation ensures consistent build configuration across team members