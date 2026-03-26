import Foundation
import Combine

@MainActor
class CollectionViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var selectedCategory: Category? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let itemService: ItemServiceProtocol

    init(itemService: ItemServiceProtocol = AppDependencies.itemService) {
        self.itemService = itemService
        loadItems()
    }

    func loadItems() {
        isLoading = true
        Task {
            do {
                items = try await itemService.getAll()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    var filteredItems: [Item] {
        if let category = selectedCategory {
            return items.filter { $0.category == category }
        } else {
            return items
        }
    }

    func addItem(_ item: Item) {
        Task {
            do {
                try await itemService.add(item)
                items = try await itemService.getAll()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func updateItem(_ item: Item) {
        Task {
            do {
                try await itemService.update(item)
                items = try await itemService.getAll()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func deleteItem(_ item: Item) {
        Task {
            do {
                try await itemService.delete(item)
                items = try await itemService.getAll()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
