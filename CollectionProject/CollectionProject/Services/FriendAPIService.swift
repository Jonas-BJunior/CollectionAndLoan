import Foundation

/// Communicates with the real REST API for friends.
/// Replace the TODO comments with actual endpoint paths when the API is ready.
final class FriendAPIService: FriendServiceProtocol {

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func getAll() async throws -> [Friend] {
        // TODO: confirm endpoint path with API team
        return try await client.get("/friends")
    }

    func get(by id: UUID) async throws -> Friend? {
        // TODO: confirm endpoint path with API team
        return try await client.get("/friends/\(id.uuidString)")
    }

    func add(_ friend: Friend) async throws {
        // TODO: confirm endpoint path with API team
        let _: Friend = try await client.post("/friends", body: friend)
    }

    func update(_ friend: Friend) async throws {
        // TODO: confirm endpoint path with API team
        let _: Friend = try await client.put("/friends/\(friend.id.uuidString)", body: friend)
    }

    func remove(_ friend: Friend) async throws {
        // TODO: confirm endpoint path with API team
        try await client.delete("/friends/\(friend.id.uuidString)")
    }
}
