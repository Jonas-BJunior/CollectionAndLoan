import Foundation

protocol ItemServiceProtocol {
    func getAll() async throws -> [Item]
    func get(by id: UUID) async throws -> Item?
    func add(_ item: Item) async throws
    func update(_ item: Item) async throws
    func delete(_ item: Item) async throws
}
