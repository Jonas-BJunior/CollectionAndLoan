import Foundation

protocol FriendServiceProtocol {
    func getAll() async throws -> [Friend]
    func get(by id: UUID) async throws -> Friend?
    func add(_ friend: Friend) async throws
    func update(_ friend: Friend) async throws
    func remove(_ friend: Friend) async throws
}
