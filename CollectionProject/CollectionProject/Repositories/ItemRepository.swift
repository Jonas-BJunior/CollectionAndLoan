import Foundation

class ItemRepository {
    private var items: [Item] = []
    
    init() {
        // Sample data
        items = [
            Item(title: "The Witcher 3", category: .game, platform: "PC", notes: "Epic RPG"),
            Item(title: "Dune", category: .book, notes: "Sci-fi classic"),
            Item(title: "Inception", category: .movie, platform: "Blu-ray"),
            Item(title: "Catan", category: .boardgame, notes: "Fun board game")
        ]
    }
    
    func reset() {
        items = [
            Item(title: "The Witcher 3", category: .game, platform: "PC", notes: "Epic RPG"),
            Item(title: "Dune", category: .book, notes: "Sci-fi classic"),
            Item(title: "Inception", category: .movie, platform: "Blu-ray"),
            Item(title: "Catan", category: .boardgame, notes: "Fun board game")
        ]
    }
    
    func getAll() -> [Item] {
        return items
    }
    
    func add(_ item: Item) {
        items.append(item)
    }
    
    func update(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        }
    }
    
    func delete(_ item: Item) {
        items.removeAll { $0.id == item.id }
    }
    
    func get(by id: UUID) -> Item? {
        return items.first { $0.id == id }
    }
}
