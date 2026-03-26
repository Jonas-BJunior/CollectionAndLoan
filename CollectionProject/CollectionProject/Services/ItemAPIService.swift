import Foundation

/// Communicates with the real REST API for items.
/// Replace the TODO comments with actual endpoint paths when the API is ready.
final class ItemAPIService: ItemServiceProtocol {

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func getAll() async throws -> [Item] {
        // TODO: confirm endpoint path with API team
        return try await client.get("/items")
    }

    func get(by id: UUID) async throws -> Item? {
        // TODO: confirm endpoint path with API team
        return try await client.get("/items/\(id.uuidString)")
    }

    func add(_ item: Item) async throws {
        // TODO: confirm endpoint path with API team
        let _: Item = try await client.post("/items", body: item)
    }

    func update(_ item: Item) async throws {
        // TODO: confirm endpoint path with API team
        let _: Item = try await client.put("/items/\(item.id.uuidString)", body: item)
    }

    func delete(_ item: Item) async throws {
        // TODO: confirm endpoint path with API team
        try await client.delete("/items/\(item.id.uuidString)")
    }
}
