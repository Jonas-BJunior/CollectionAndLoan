import XCTest
@testable import CollectionProject

// MARK: - Model Tests (sync, no change)

class ItemModelTests: XCTestCase {

    func testItemCreationWithDefaults() {
        let item = Item(title: "Test Game", category: .game)
        XCTAssertEqual(item.title, "Test Game")
        XCTAssertEqual(item.category, .game)
        XCTAssertNil(item.platform)
        XCTAssertNil(item.coverImage)
        XCTAssertNil(item.notes)
        XCTAssertEqual(item.status, .available)
    }

    func testItemCreationWithAllProperties() {
        let item = Item(
            title: "Dune",
            category: .book,
            platform: "PDF",
            coverImage: "dune.jpg",
            notes: "Sci-fi classic",
            status: .lent
        )
        XCTAssertEqual(item.title, "Dune")
        XCTAssertEqual(item.category, .book)
        XCTAssertEqual(item.platform, "PDF")
        XCTAssertEqual(item.coverImage, "dune.jpg")
        XCTAssertEqual(item.notes, "Sci-fi classic")
        XCTAssertEqual(item.status, .lent)
    }

    func testItemStatusTransitions() {
        var item = Item(title: "Game", category: .game, status: .available)
        XCTAssertEqual(item.status, .available)
        item.status = .lent
        XCTAssertEqual(item.status, .lent)
        item.status = .available
        XCTAssertEqual(item.status, .available)
    }

    func testCategoryAllCases() {
        let categories = Category.allCases
        XCTAssertEqual(categories.count, 5)
        XCTAssertTrue(categories.contains(.game))
        XCTAssertTrue(categories.contains(.book))
        XCTAssertTrue(categories.contains(.movie))
        XCTAssertTrue(categories.contains(.boardgame))
        XCTAssertTrue(categories.contains(.other))
    }

    func testItemIdentifiability() {
        let item1 = Item(title: "Game", category: .game)
        let item2 = Item(title: "Game", category: .game)
        XCTAssertNotEqual(item1.id, item2.id)
    }

    func testItemIsCodable() throws {
        let item = Item(title: "Codable Game", category: .game, platform: "PC", notes: "Test")
        let data = try JSONEncoder().encode(item)
        let decoded = try JSONDecoder().decode(Item.self, from: data)
        XCTAssertEqual(decoded.id, item.id)
        XCTAssertEqual(decoded.title, item.title)
        XCTAssertEqual(decoded.category, item.category)
    }
}

class FriendModelTests: XCTestCase {

    func testFriendCreationWithoutEmail() {
        let friend = Friend(name: "Alice")
        XCTAssertEqual(friend.name, "Alice")
        XCTAssertNil(friend.email)
    }

    func testFriendCreationWithEmail() {
        let friend = Friend(name: "Bob", email: "bob@example.com")
        XCTAssertEqual(friend.name, "Bob")
        XCTAssertEqual(friend.email, "bob@example.com")
    }

    func testFriendIdentifiability() {
        let friend1 = Friend(name: "Alice")
        let friend2 = Friend(name: "Alice")
        XCTAssertNotEqual(friend1.id, friend2.id)
    }

    func testFriendIsCodable() throws {
        let friend = Friend(name: "Alice", email: "alice@example.com")
        let data = try JSONEncoder().encode(friend)
        let decoded = try JSONDecoder().decode(Friend.self, from: data)
        XCTAssertEqual(decoded.id, friend.id)
        XCTAssertEqual(decoded.name, friend.name)
        XCTAssertEqual(decoded.email, friend.email)
    }
}

class LoanModelTests: XCTestCase {

    func testLoanCreationWithoutReturnDate() {
        let itemId = UUID()
        let friendId = UUID()
        let loanDate = Date()
        let loan = Loan(itemId: itemId, friendId: friendId, loanDate: loanDate, returnDate: nil)
        XCTAssertEqual(loan.itemId, itemId)
        XCTAssertEqual(loan.friendId, friendId)
        XCTAssertEqual(loan.loanDate, loanDate)
        XCTAssertNil(loan.returnDate)
    }

    func testLoanCreationWithReturnDate() {
        let itemId = UUID()
        let friendId = UUID()
        let loanDate = Date()
        let returnDate = Date().addingTimeInterval(86400)
        let loan = Loan(itemId: itemId, friendId: friendId, loanDate: loanDate, returnDate: returnDate)
        XCTAssertEqual(loan.returnDate, returnDate)
    }

    func testLoanIdentifiability() {
        let itemId = UUID()
        let friendId = UUID()
        let loan1 = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        let loan2 = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        XCTAssertNotEqual(loan1.id, loan2.id)
    }

    func testLoanIsCodable() throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let loan = Loan(itemId: UUID(), friendId: UUID(), loanDate: Date(), returnDate: nil)
        let data = try encoder.encode(loan)
        let decoded = try decoder.decode(Loan.self, from: data)
        XCTAssertEqual(decoded.id, loan.id)
        XCTAssertEqual(decoded.itemId, loan.itemId)
    }
}

// MARK: - Mock Service Tests (replace Repository Tests)

class MockItemServiceTests: XCTestCase {

    var service: MockItemService!

    override func setUp() {
        service = MockItemService()
    }

    func testInitializesWithSeedData() async throws {
        let items = try await service.getAll()
        XCTAssertEqual(items.count, 4)
        let titles = items.map { $0.title }
        XCTAssertTrue(titles.contains("The Witcher 3"))
        XCTAssertTrue(titles.contains("Dune"))
        XCTAssertTrue(titles.contains("Inception"))
        XCTAssertTrue(titles.contains("Catan"))
    }

    func testAddItem() async throws {
        let newItem = Item(title: "New Game", category: .game)
        let initial = try await service.getAll()
        try await service.add(newItem)
        let all = try await service.getAll()
        XCTAssertEqual(all.count, initial.count + 1)
        XCTAssertTrue(all.contains { $0.id == newItem.id })
    }

    func testGetItemById() async throws {
        let items = try await service.getAll()
        let first = items[0]
        let retrieved = try await service.get(by: first.id)
        XCTAssertEqual(retrieved?.id, first.id)
        XCTAssertEqual(retrieved?.title, first.title)
    }

    func testGetNonExistentItem() async throws {
        let result = try await service.get(by: UUID())
        XCTAssertNil(result)
    }

    func testUpdateItem() async throws {
        var item = try await service.getAll().first!
        let id = item.id
        item.title = "Updated Title"
        try await service.update(item)
        let updated = try await service.get(by: id)
        XCTAssertEqual(updated?.title, "Updated Title")
    }

    func testDeleteItem() async throws {
        let item = try await service.getAll().first!
        let initial = try await service.getAll()
        try await service.delete(item)
        let all = try await service.getAll()
        XCTAssertEqual(all.count, initial.count - 1)
        let deleted = try await service.get(by: item.id)
        XCTAssertNil(deleted)
    }

    func testResetRestoresSeedData() async throws {
        try await service.add(Item(title: "Extra", category: .other))
        service.reset()
        let items = try await service.getAll()
        XCTAssertEqual(items.count, 4)
    }
}

class MockFriendServiceTests: XCTestCase {

    var service: MockFriendService!

    override func setUp() {
        service = MockFriendService()
    }

    func testInitializesWithSeedData() async throws {
        let friends = try await service.getAll()
        XCTAssertEqual(friends.count, 2)
        XCTAssertTrue(friends.map { $0.name }.contains("Alice"))
        XCTAssertTrue(friends.map { $0.name }.contains("Bob"))
    }

    func testAddFriend() async throws {
        let newFriend = Friend(name: "Charlie", email: "charlie@example.com")
        let initial = try await service.getAll()
        try await service.add(newFriend)
        let all = try await service.getAll()
        XCTAssertEqual(all.count, initial.count + 1)
        XCTAssertTrue(all.contains { $0.id == newFriend.id })
    }

    func testGetFriendById() async throws {
        let first = try await service.getAll().first!
        let retrieved = try await service.get(by: first.id)
        XCTAssertEqual(retrieved?.id, first.id)
        XCTAssertEqual(retrieved?.name, first.name)
    }

    func testUpdateFriend() async throws {
        var friend = try await service.getAll().first!
        let id = friend.id
        friend.name = "Alice Updated"
        try await service.update(friend)
        let updated = try await service.get(by: id)
        XCTAssertEqual(updated?.name, "Alice Updated")
    }

    func testRemoveFriend() async throws {
        let friend = try await service.getAll().first!
        let initial = try await service.getAll()
        try await service.remove(friend)
        let all = try await service.getAll()
        XCTAssertEqual(all.count, initial.count - 1)
        let deleted = try await service.get(by: friend.id)
        XCTAssertNil(deleted)
    }
}

class MockLoanServiceTests: XCTestCase {

    var service: MockLoanService!
    var itemId: UUID!
    var friendId: UUID!

    override func setUp() {
        service = MockLoanService()
        itemId = UUID()
        friendId = UUID()
    }

    func testInitializesEmpty() async throws {
        let loans = try await service.getAll()
        XCTAssertEqual(loans.count, 0)
    }

    func testAddLoan() async throws {
        let loan = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        try await service.add(loan)
        let loans = try await service.getAll()
        XCTAssertEqual(loans.count, 1)
        XCTAssertTrue(loans.contains { $0.id == loan.id })
    }

    func testGetLoanById() async throws {
        let loan = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        try await service.add(loan)
        let retrieved = try await service.get(by: loan.id)
        XCTAssertEqual(retrieved?.id, loan.id)
    }

    func testUpdateLoan() async throws {
        let loan = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        try await service.add(loan)
        var updated = loan
        updated.returnDate = Date()
        try await service.update(updated)
        let retrieved = try await service.get(by: loan.id)
        XCTAssertNotNil(retrieved?.returnDate)
    }

    func testDeleteLoan() async throws {
        let loan = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        try await service.add(loan)
        try await service.delete(loan)
        let deleted = try await service.get(by: loan.id)
        XCTAssertNil(deleted)
    }

    func testGetLoansByItem() async throws {
        let loan1 = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        let loan2 = Loan(itemId: itemId, friendId: UUID(), loanDate: Date())
        let loan3 = Loan(itemId: UUID(), friendId: friendId, loanDate: Date())
        try await service.add(loan1)
        try await service.add(loan2)
        try await service.add(loan3)
        let result = try await service.getLoans(for: itemId)
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.contains { $0.id == loan1.id })
        XCTAssertTrue(result.contains { $0.id == loan2.id })
    }

    func testGetLoansByFriend() async throws {
        let loan1 = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        let loan2 = Loan(itemId: UUID(), friendId: friendId, loanDate: Date())
        let loan3 = Loan(itemId: UUID(), friendId: UUID(), loanDate: Date())
        try await service.add(loan1)
        try await service.add(loan2)
        try await service.add(loan3)
        let result = try await service.getLoansByFriend(for: friendId)
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.contains { $0.id == loan1.id })
        XCTAssertTrue(result.contains { $0.id == loan2.id })
    }

    func testResetClearsLoans() async throws {
        try await service.add(Loan(itemId: itemId, friendId: friendId, loanDate: Date()))
        service.reset()
        let loans = try await service.getAll()
        XCTAssertEqual(loans.count, 0)
    }
}

// MARK: - ViewModel Tests

@MainActor
class CollectionViewModelTests: XCTestCase {

    var mockService: MockItemService!
    var viewModel: CollectionViewModel!

    override func setUp() async throws {
        mockService = MockItemService()
        viewModel = CollectionViewModel(itemService: mockService)
        try await Task.sleep(nanoseconds: 50_000_000)
    }

    func testViewModelLoadsItems() {
        XCTAssertGreaterThan(viewModel.items.count, 0)
    }

    func testFilteredItemsWithoutCategory() {
        XCTAssertEqual(viewModel.filteredItems.count, viewModel.items.count)
    }

    func testFilteredItemsByCategory() async throws {
        viewModel.selectedCategory = .game
        let filtered = viewModel.filteredItems
        XCTAssertTrue(filtered.allSatisfy { $0.category == .game })
        XCTAssertGreaterThan(filtered.count, 0)
    }

    func testAddItem() async throws {
        let initialCount = viewModel.items.count
        let newItem = Item(title: "New Item", category: .book)
        viewModel.addItem(newItem)
        try await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertEqual(viewModel.items.count, initialCount + 1)
        XCTAssertTrue(viewModel.items.contains { $0.id == newItem.id })
    }

    func testDeleteItem() async throws {
        let itemToDelete = viewModel.items[0]
        let initialCount = viewModel.items.count
        viewModel.deleteItem(itemToDelete)
        try await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertEqual(viewModel.items.count, initialCount - 1)
        XCTAssertFalse(viewModel.items.contains { $0.id == itemToDelete.id })
    }

    func testUpdateItem() async throws {
        var item = viewModel.items[0]
        item.title = "Updated Title"
        viewModel.updateItem(item)
        try await Task.sleep(nanoseconds: 50_000_000)
        let updated = viewModel.items.first { $0.id == item.id }
        XCTAssertEqual(updated?.title, "Updated Title")
    }
}

@MainActor
class FriendsViewModelTests: XCTestCase {

    var mockService: MockFriendService!
    var viewModel: FriendsViewModel!

    override func setUp() async throws {
        mockService = MockFriendService()
        viewModel = FriendsViewModel(friendService: mockService)
        try await Task.sleep(nanoseconds: 50_000_000)
    }

    func testViewModelLoadsFriends() {
        XCTAssertGreaterThan(viewModel.friends.count, 0)
    }

    func testAddFriend() async throws {
        let initialCount = viewModel.friends.count
        let newFriend = Friend(name: "Charlie")
        viewModel.addFriend(newFriend)
        try await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertEqual(viewModel.friends.count, initialCount + 1)
        XCTAssertTrue(viewModel.friends.contains { $0.id == newFriend.id })
    }

    func testRemoveFriend() async throws {
        let friendToRemove = viewModel.friends[0]
        let initialCount = viewModel.friends.count
        viewModel.removeFriend(friendToRemove)
        try await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertEqual(viewModel.friends.count, initialCount - 1)
        XCTAssertFalse(viewModel.friends.contains { $0.id == friendToRemove.id })
    }

    func testUpdateFriend() async throws {
        var friend = viewModel.friends[0]
        friend.name = "Updated Name"
        viewModel.updateFriend(friend)
        try await Task.sleep(nanoseconds: 50_000_000)
        let updated = viewModel.friends.first { $0.id == friend.id }
        XCTAssertEqual(updated?.name, "Updated Name")
    }
}

// MARK: - Integration Tests

@MainActor
class LoanIntegrationTests: XCTestCase {

    var itemService: MockItemService!
    var friendService: MockFriendService!
    var loanService: MockLoanService!
    var itemVM: CollectionViewModel!
    var friendVM: FriendsViewModel!
    var itemDetailVM: ItemDetailViewModel!

    override func setUp() async throws {
        itemService = MockItemService()
        friendService = MockFriendService()
        loanService = MockLoanService()

        itemVM = CollectionViewModel(itemService: itemService)
        friendVM = FriendsViewModel(friendService: friendService)
        try await Task.sleep(nanoseconds: 50_000_000)

        let testItem = itemVM.items[0]
        itemDetailVM = ItemDetailViewModel(
            item: testItem,
            itemService: itemService,
            loanService: loanService,
            friendService: friendService
        )
        try await Task.sleep(nanoseconds: 50_000_000)
    }

    func testLendItemCreatesLoan() async throws {
        let friend = friendVM.friends[0]
        itemDetailVM.lendItem(to: friend, loanDate: Date(), returnDate: nil)
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(itemDetailVM.loans.count, 1)
        XCTAssertEqual(itemDetailVM.loans[0].friendId, friend.id)
    }

    func testLendItemChangesItemStatus() async throws {
        let friend = friendVM.friends[0]
        itemDetailVM.lendItem(to: friend, loanDate: Date(), returnDate: nil)
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(itemDetailVM.item.status, .lent)
    }

    func testReturnBorrowedItem() async throws {
        let friend = friendVM.friends[0]
        itemDetailVM.lendItem(to: friend, loanDate: Date(), returnDate: nil)
        try await Task.sleep(nanoseconds: 100_000_000)

        let loan = itemDetailVM.loans.first { $0.returnDate == nil }!
        itemDetailVM.returnItem(loan: loan)
        try await Task.sleep(nanoseconds: 100_000_000)

        let returned = itemDetailVM.loans.first { $0.id == loan.id }
        XCTAssertNotNil(returned?.returnDate)
        XCTAssertEqual(itemDetailVM.item.status, .available)
    }

    func testGetFriendNameAsync() async throws {
        let friend = friendVM.friends[0]
        itemDetailVM.lendItem(to: friend, loanDate: Date(), returnDate: nil)
        try await Task.sleep(nanoseconds: 100_000_000)

        let loan = itemDetailVM.loans[0]
        let name = await itemDetailVM.getFriendNameAsync(for: loan)
        XCTAssertEqual(name, friend.name)
    }
}

