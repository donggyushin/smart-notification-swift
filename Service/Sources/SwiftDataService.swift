//
//  SwiftDataService.swift
//  Service
//
//  Created by 신동규 on 9/14/25.
//

import Foundation
import Domain
import SwiftData

public final class SwiftDataService: CacheRepository {

    private let modelContext: ModelContext

    public init() {
        let schema = Schema([NewsLocalDTO.self])
        let configuration = ModelConfiguration(schema: schema)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        self.modelContext = ModelContext(container)
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
}
