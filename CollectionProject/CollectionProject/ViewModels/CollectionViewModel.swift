import Foundation
import Combine

class CollectionViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var selectedCategory: Category? = nil
    
    private let itemRepository: ItemRepository
    
    init() {
        self.itemRepository = AppDependencies.itemRepository
        loadItems()
    }
    
    func loadItems() {
        items = itemRepository.getAll()
    }
    
    var filteredItems: [Item] {
        if let category = selectedCategory {
            return items.filter { $0.category == category }
        } else {
            return items
        }
    }
    
    func addItem(_ item: Item) {
        itemRepository.add(item)
        loadItems()
    }
    
    func updateItem(_ item: Item) {
        itemRepository.update(item)
        loadItems()
    }
}