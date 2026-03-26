import Foundation

/// In-memory mock implementation of ItemServiceProtocol.
/// Use while the real API is not ready. Pre-seeded with sample data.
final class MockItemService: ItemServiceProtocol {

    private var items: [Item] = [
        Item(title: "The Witcher 3", category: .game, platform: "PC", notes: "Epic RPG"),
        Item(title: "Dune",          category: .book,      notes: "Sci-fi classic"),
        Item(title: "Inception",     category: .movie,     platform: "Blu-ray"),
        Item(title: "Catan",         category: .boardgame, notes: "Fun board game")
    ]

    func getAll() async throws -> [Item] {
        return items
    }

    func get(by id: UUID) async throws -> Item? {
        return items.first { $0.id == id }
    }

    func add(_ item: Item) async throws {
        items.append(item)
    }

    func update(_ item: Item) async throws {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index] = item
    }

    func delete(_ item: Item) async throws {
        items.removeAll { $0.id == item.id }
    }

    // MARK: - Test helper
    func reset() {
        items = [
            Item(title: "The Witcher 3", category: .game, platform: "PC", notes: "Epic RPG"),
            Item(title: "Dune",          category: .book,      notes: "Sci-fi classic"),
            Item(title: "Inception",     category: .movie,     platform: "Blu-ray"),
            Item(title: "Catan",         category: .boardgame, notes: "Fun board game")
        ]
    }
}
