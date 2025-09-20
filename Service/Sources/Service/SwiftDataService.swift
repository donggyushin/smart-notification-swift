//
//  SwiftDataService.swift
//  Service
//
//  Created by 신동규 on 9/14/25.
//

import Foundation
import Domain
import SwiftData

final class SwiftDataService {

    private let modelContext: ModelContext

    init() {
        do {
            let container = try ModelContainer(for: NewsLocalDTO.self, SavedNewsLocalDTO.self)
            self.modelContext = ModelContext(container)
        } catch {
            print("Failed to create ModelContainer: \(error)")
            // Fallback: create container with explicit schema
            let schema = Schema([NewsLocalDTO.self, SavedNewsLocalDTO.self])
            let configuration = ModelConfiguration(schema: schema)
            let container = try! ModelContainer(for: schema, configurations: [configuration])
            self.modelContext = ModelContext(container)
        }
    }

    func getNews() -> [NewsEntity] {
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

    func saveNews(_ news: [NewsEntity]) {
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

    func updateNewsSaveStatus(newsId: Int, isSaved: Bool) {
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

    func clearAllNewsData() {
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

    func saveSavedNews(_ news: [NewsEntity]) {
        for newsItem in news {
            // Check if item already exists in saved news
            let itemId = newsItem.id
            let predicate = #Predicate<SavedNewsLocalDTO> { dto in
                dto.id == itemId
            }
            let descriptor = FetchDescriptor<SavedNewsLocalDTO>(predicate: predicate)

            do {
                let existingItems = try modelContext.fetch(descriptor)
                if existingItems.isEmpty {
                    let dto = SavedNewsLocalDTO(from: newsItem)
                    modelContext.insert(dto)
                }
            } catch {
                print("Failed to check existing saved news item: \(error)")
            }
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to save saved news: \(error)")
        }
    }

    func getSavedNews() -> [NewsEntity] {
        let descriptor = FetchDescriptor<SavedNewsLocalDTO>(
            sortBy: [SortDescriptor(\.created_at, order: .reverse)]
        )

        do {
            let dtos = try modelContext.fetch(descriptor)
            return dtos.map { $0.toDomain() }
        } catch {
            print("Failed to fetch saved news: \(error)")
            return []
        }
    }

    func clearSavedNews() {
        let descriptor = FetchDescriptor<SavedNewsLocalDTO>()

        do {
            let allItems = try modelContext.fetch(descriptor)
            for item in allItems {
                modelContext.delete(item)
            }
            try modelContext.save()
        } catch {
            print("Failed to clear saved news: \(error)")
        }
    }
}
