//
//  SwiftDataService.swift
//  Service
//
//  Created by 신동규 on 9/14/25.
//

import Foundation
import Domain
import SwiftData

public final class SwiftDataService {

    private let modelContext: ModelContext

    public init() {
        do {
            let container = try ModelContainer(for: NewsLocalDTO.self)
            self.modelContext = ModelContext(container)
        } catch {
            print("Failed to create ModelContainer: \(error)")
            // Fallback: create container with explicit schema
            let schema = Schema([NewsLocalDTO.self])
            let configuration = ModelConfiguration(schema: schema)
            let container = try! ModelContainer(for: schema, configurations: [configuration])
            self.modelContext = ModelContext(container)
        }
    }

    public func getNews() -> [NewsEntity] {
        let descriptor = FetchDescriptor<NewsLocalDTO>(
            sortBy: [SortDescriptor(\.created_at, order: .reverse)]
        )

        do {
            let dtos = try modelContext.fetch(descriptor)
            return dtos.map { $0.toDomain() }
        } catch {
            print("Failed to fetch cached news: \(error)")
            return []
        }
    }

    public func saveNews(_ news: [NewsEntity]) {
        for newsItem in news {
            // Check if item already exists
            let itemId = newsItem.id
            let predicate = #Predicate<NewsLocalDTO> { dto in
                dto.id == itemId
            }
            let descriptor = FetchDescriptor<NewsLocalDTO>(predicate: predicate)

            do {
                let existingItems = try modelContext.fetch(descriptor)
                if existingItems.isEmpty {
                    let dto = NewsLocalDTO(from: newsItem)
                    modelContext.insert(dto)
                }
            } catch {
                print("Failed to check existing news item: \(error)")
            }
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to save cached news: \(error)")
        }
    }

    public func updateNewsSaveStatus(newsId: Int, isSaved: Bool) {
        let predicate = #Predicate<NewsLocalDTO> { dto in
            dto.id == newsId
        }
        let descriptor = FetchDescriptor<NewsLocalDTO>(predicate: predicate)

        do {
            let existingItems = try modelContext.fetch(descriptor)
            if let item = existingItems.first {
                item.save = isSaved
                try modelContext.save()
            }
        } catch {
            print("Failed to update news save status: \(error)")
        }
    }

    public func clearAllNewsData() {
        let descriptor = FetchDescriptor<NewsLocalDTO>()

        do {
            let allItems = try modelContext.fetch(descriptor)
            for item in allItems {
                modelContext.delete(item)
            }
            try modelContext.save()
        } catch {
            print("Failed to clear all news data: \(error)")
        }
    }
}
