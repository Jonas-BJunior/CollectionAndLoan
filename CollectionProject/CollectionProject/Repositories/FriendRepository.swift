import Foundation

class FriendRepository {
    private var friends: [Friend] = []
    
    init() {
        // Sample data
        friends = [
            Friend(name: "Alice", email: "alice@example.com"),
            Friend(name: "Bob", email: "bob@example.com")
        ]
    }
    
    func getAll() -> [Friend] {
        return friends
    }
    
    func add(_ friend: Friend) {
        friends.append(friend)
    }
    
    func update(_ friend: Friend) {
        if let index = friends.firstIndex(where: { $0.id == friend.id }) {
            friends[index] = friend
        }
    }
    
    func get(by id: UUID) -> Friend? {
        return friends.first { $0.id == id }
    }
    
    func delete(_ friend: Friend) {
        friends.removeAll { $0.id == friend.id }
    }
}