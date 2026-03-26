import Foundation
@testable import CollectionProject

// Test-only in-memory services used by unit and integration tests.
final class MockItemService: ItemServiceProtocol {

    private var items: [Item] = [
        Item(title: "The Witcher 3", category: .game, platform: "PC", notes: "Epic RPG"),
        Item(title: "Dune", category: .book, notes: "Sci-fi classic"),
        Item(title: "Inception", category: .movie, platform: "Blu-ray"),
        Item(title: "Catan", category: .boardgame, notes: "Fun board game")
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

    func reset() {
        items = [
            Item(title: "The Witcher 3", category: .game, platform: "PC", notes: "Epic RPG"),
            Item(title: "Dune", category: .book, notes: "Sci-fi classic"),
            Item(title: "Inception", category: .movie, platform: "Blu-ray"),
            Item(title: "Catan", category: .boardgame, notes: "Fun board game")
        ]
    }
}

final class MockFriendService: FriendServiceProtocol {

    private var friends: [Friend] = [
        Friend(name: "Alice", email: "alice@example.com"),
        Friend(name: "Bob", email: "bob@example.com")
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

    func reset() {
        friends = [
            Friend(name: "Alice", email: "alice@example.com"),
            Friend(name: "Bob", email: "bob@example.com")
        ]
    }
}

final class MockLoanService: LoanServiceProtocol {

    private var loans: [Loan] = []

    func getAll() async throws -> [Loan] {
        return loans
    }

    func get(by id: UUID) async throws -> Loan? {
        return loans.first { $0.id == id }
    }

    func getLoans(for itemId: UUID) async throws -> [Loan] {
        return loans.filter { $0.itemId == itemId }
    }

    func getLoansByFriend(for friendId: UUID) async throws -> [Loan] {
        return loans.filter { $0.friendId == friendId }
    }

    func add(_ loan: Loan) async throws {
        loans.append(loan)
    }

    func update(_ loan: Loan) async throws {
        guard let index = loans.firstIndex(where: { $0.id == loan.id }) else { return }
        loans[index] = loan
    }

    func delete(_ loan: Loan) async throws {
        loans.removeAll { $0.id == loan.id }
    }

    func reset() {
        loans = []
    }
}
