import Foundation

/// In-memory mock implementation of FriendServiceProtocol.
/// Use while the real API is not ready. Pre-seeded with sample data.
final class MockFriendService: FriendServiceProtocol {

    private var friends: [Friend] = [
        Friend(name: "Alice", email: "alice@example.com"),
        Friend(name: "Bob",   email: "bob@example.com")
    ]

    func getAll() async throws -> [Friend] {
        return friends
    }

    func get(by id: UUID) async throws -> Friend? {
        return friends.first { $0.id == id }
    }

    func add(_ friend: Friend) async throws {
        friends.append(friend)
    }

    func update(_ friend: Friend) async throws {
        guard let index = friends.firstIndex(where: { $0.id == friend.id }) else { return }
        friends[index] = friend
    }

    func remove(_ friend: Friend) async throws {
        friends.removeAll { $0.id == friend.id }
    }

    // MARK: - Test helper
    func reset() {
        friends = [
            Friend(name: "Alice", email: "alice@example.com"),
            Friend(name: "Bob",   email: "bob@example.com")
        ]
    }
}
