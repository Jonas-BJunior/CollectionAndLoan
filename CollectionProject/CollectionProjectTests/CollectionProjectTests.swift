import XCTest
@testable import CollectionProject

// MARK: - Unit Tests
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
        
        // Each item should have unique ID
        XCTAssertNotEqual(item1.id, item2.id)
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
        let returnDate = Date().addingTimeInterval(86400) // +1 day
        
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
}

// MARK: - Repository Tests
class ItemRepositoryTests: XCTestCase {
    
    var repository: ItemRepository!
    
    override func setUpWithError() throws {
        repository = ItemRepository()
    }
    
    func testRepositoryInitializesWithExampleData() {
        let items = repository.getAll()
        XCTAssertEqual(items.count, 4)
        
        let titles = items.map { $0.title }
        XCTAssertTrue(titles.contains("The Witcher 3"))
        XCTAssertTrue(titles.contains("Dune"))
        XCTAssertTrue(titles.contains("Inception"))
        XCTAssertTrue(titles.contains("Catan"))
    }
    
    func testAddItem() {
        let newItem = Item(title: "New Game", category: .game)
        let initialCount = repository.getAll().count
        
        repository.add(newItem)
        
        XCTAssertEqual(repository.getAll().count, initialCount + 1)
        XCTAssertTrue(repository.getAll().contains { $0.id == newItem.id })
    }
    
    func testGetItemById() {
        let items = repository.getAll()
        let firstItem = items[0]
        
        let retrieved = repository.get(by: firstItem.id)
        
        XCTAssertEqual(retrieved?.id, firstItem.id)
        XCTAssertEqual(retrieved?.title, firstItem.title)
    }
    
    func testGetNonExistentItem() {
        let nonExistentId = UUID()
        let retrieved = repository.get(by: nonExistentId)
        
        XCTAssertNil(retrieved)
    }
    
    func testUpdateItem() {
        var item = repository.getAll()[0]
        let originalId = item.id
        item.title = "Updated Title"
        
        repository.update(item)
        
        let updated = repository.get(by: originalId)
        XCTAssertEqual(updated?.title, "Updated Title")
    }
    
    func testDeleteItem() {
        let item = repository.getAll()[0]
        let itemId = item.id
        let initialCount = repository.getAll().count
        
        repository.delete(item)
        
        XCTAssertEqual(repository.getAll().count, initialCount - 1)
        XCTAssertNil(repository.get(by: itemId))
    }
}

class FriendRepositoryTests: XCTestCase {
    
    var repository: FriendRepository!
    
    override func setUpWithError() throws {
        repository = FriendRepository()
    }
    
    func testRepositoryInitializesWithExampleData() {
        let friends = repository.getAll()
        XCTAssertEqual(friends.count, 2)
        
        let names = friends.map { $0.name }
        XCTAssertTrue(names.contains("Alice"))
        XCTAssertTrue(names.contains("Bob"))
    }
    
    func testAddFriend() {
        let newFriend = Friend(name: "Charlie", email: "charlie@example.com")
        let initialCount = repository.getAll().count
        
        repository.add(newFriend)
        
        XCTAssertEqual(repository.getAll().count, initialCount + 1)
        XCTAssertTrue(repository.getAll().contains { $0.id == newFriend.id })
    }
    
    func testGetFriendById() {
        let friends = repository.getAll()
        let firstFriend = friends[0]
        
        let retrieved = repository.get(by: firstFriend.id)
        
        XCTAssertEqual(retrieved?.id, firstFriend.id)
        XCTAssertEqual(retrieved?.name, firstFriend.name)
    }
    
    func testUpdateFriend() {
        var friend = repository.getAll()[0]
        let originalId = friend.id
        friend.name = "Alice Updated"
        
        repository.update(friend)
        
        let updated = repository.get(by: originalId)
        XCTAssertEqual(updated?.name, "Alice Updated")
    }
    
    func testDeleteFriend() {
        let friend = repository.getAll()[0]
        let friendId = friend.id
        let initialCount = repository.getAll().count
        
        repository.delete(friend)
        
        XCTAssertEqual(repository.getAll().count, initialCount - 1)
        XCTAssertNil(repository.get(by: friendId))
    }
    
    func testRemoveFriend() {
        let friend = repository.getAll()[0]
        let friendId = friend.id
        
        repository.remove(friend)
        
        XCTAssertNil(repository.get(by: friendId))
    }
}

class LoanRepositoryTests: XCTestCase {
    
    var repository: LoanRepository!
    var itemId: UUID!
    var friendId: UUID!
    
    override func setUpWithError() throws {
        repository = LoanRepository()
        itemId = UUID()
        friendId = UUID()
    }
    
    func testRepositoryInitializesEmpty() {
        let loans = repository.getAll()
        XCTAssertEqual(loans.count, 0)
    }
    
    func testAddLoan() {
        let loan = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        
        repository.add(loan)
        
        XCTAssertEqual(repository.getAll().count, 1)
        XCTAssertTrue(repository.getAll().contains { $0.id == loan.id })
    }
    
    func testGetLoanById() {
        let loan = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        repository.add(loan)
        
        let retrieved = repository.get(by: loan.id)
        
        XCTAssertEqual(retrieved?.id, loan.id)
    }
    
    func testUpdateLoan() {
        let loan = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        repository.add(loan)
        
        var updatedLoan = loan
        updatedLoan.returnDate = Date()
        repository.update(updatedLoan)
        
        let retrieved = repository.get(by: loan.id)
        XCTAssertNotNil(retrieved?.returnDate)
    }
    
    func testDeleteLoan() {
        let loan = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        repository.add(loan)
        
        repository.delete(loan)
        
        XCTAssertNil(repository.get(by: loan.id))
    }
    
    func testGetLoansByItem() {
        let loan1 = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        let loan2 = Loan(itemId: itemId, friendId: UUID(), loanDate: Date())
        let loan3 = Loan(itemId: UUID(), friendId: friendId, loanDate: Date())
        
        repository.add(loan1)
        repository.add(loan2)
        repository.add(loan3)
        
        let itemLoans = repository.getLoans(for: itemId)
        
        XCTAssertEqual(itemLoans.count, 2)
        XCTAssertTrue(itemLoans.contains { $0.id == loan1.id })
        XCTAssertTrue(itemLoans.contains { $0.id == loan2.id })
    }
    
    func testGetLoansByFriend() {
        let loan1 = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        let loan2 = Loan(itemId: itemId, friendId: friendId, loanDate: Date())
        let loan3 = Loan(itemId: UUID(), friendId: UUID(), loanDate: Date())
        
        repository.add(loan1)
        repository.add(loan2)
        repository.add(loan3)
        
        let friendLoans = repository.getLoansByFriend(for: friendId)
        
        XCTAssertEqual(friendLoans.count, 2)
        XCTAssertTrue(friendLoans.contains { $0.id == loan1.id })
        XCTAssertTrue(friendLoans.contains { $0.id == loan2.id })
    }
}

// MARK: - ViewModel Tests
class CollectionViewModelTests: XCTestCase {
    
    var viewModel: CollectionViewModel!
    
    override func setUpWithError() throws {
        // Reset repositories to clean state
        AppDependencies.itemRepository.reset()
        AppDependencies.friendRepository.reset()
        AppDependencies.loanRepository.reset()
        
        viewModel = CollectionViewModel()
    }
    
    func testViewModelLoadsItems() {
        XCTAssertGreaterThan(viewModel.items.count, 0)
    }
    
    func testFilteredItemsWithoutCategory() {
        let filtered = viewModel.filteredItems
        XCTAssertEqual(filtered.count, viewModel.items.count)
    }
    
    func testFilteredItemsByCategory() {
        viewModel.selectedCategory = .game
        let filtered = viewModel.filteredItems
        
        XCTAssertTrue(filtered.allSatisfy { $0.category == .game })
        XCTAssertGreaterThan(filtered.count, 0)
    }
    
    func testAddItem() {
        let initialCount = viewModel.items.count
        let newItem = Item(title: "New Item", category: .book)
        
        viewModel.addItem(newItem)
        
        XCTAssertEqual(viewModel.items.count, initialCount + 1)
        XCTAssertTrue(viewModel.items.contains { $0.id == newItem.id })
    }
    
    func testDeleteItem() {
        let itemToDelete = viewModel.items[0]
        let initialCount = viewModel.items.count
        
        viewModel.deleteItem(itemToDelete)
        
        XCTAssertEqual(viewModel.items.count, initialCount - 1)
        XCTAssertFalse(viewModel.items.contains { $0.id == itemToDelete.id })
    }
    
    func testUpdateItem() {
        var item = viewModel.items[0]
        let originalTitle = item.title
        item.title = "Updated Title"
        
        viewModel.updateItem(item)
        
        let updated = viewModel.items.first { $0.id == item.id }
        XCTAssertEqual(updated?.title, "Updated Title")
        XCTAssertNotEqual(updated?.title, originalTitle)
    }
}

class FriendsViewModelTests: XCTestCase {
    
    var viewModel: FriendsViewModel!
    
    override func setUpWithError() throws {
        viewModel = FriendsViewModel()
    }
    
    func testViewModelLoadsFriends() {
        XCTAssertGreaterThan(viewModel.friends.count, 0)
    }
    
    func testAddFriend() {
        let initialCount = viewModel.friends.count
        let newFriend = Friend(name: "Charlie")
        
        viewModel.addFriend(newFriend)
        
        XCTAssertEqual(viewModel.friends.count, initialCount + 1)
        XCTAssertTrue(viewModel.friends.contains { $0.id == newFriend.id })
    }
    
    func testRemoveFriend() {
        let friendToRemove = viewModel.friends[0]
        let initialCount = viewModel.friends.count
        
        viewModel.removeFriend(friendToRemove)
        
        XCTAssertEqual(viewModel.friends.count, initialCount - 1)
        XCTAssertFalse(viewModel.friends.contains { $0.id == friendToRemove.id })
    }
    
    func testUpdateFriend() {
        var friend = viewModel.friends[0]
        let originalName = friend.name
        friend.name = "Updated Name"
        
        viewModel.updateFriend(friend)
        
        let updated = viewModel.friends.first { $0.id == friend.id }
        XCTAssertEqual(updated?.name, "Updated Name")
        XCTAssertNotEqual(updated?.name, originalName)
    }
}

// MARK: - Integration Tests
class LoanIntegrationTests: XCTestCase {
    
    var itemVM: CollectionViewModel!
    var friendVM: FriendsViewModel!
    var itemDetailVM: ItemDetailViewModel!
    
    override func setUpWithError() throws {
        // Reset repositories to clean state
        AppDependencies.itemRepository.reset()
        AppDependencies.friendRepository.reset()
        AppDependencies.loanRepository.reset()
        
        itemVM = CollectionViewModel()
        friendVM = FriendsViewModel()
        let testItem = itemVM.items[0]
        itemDetailVM = ItemDetailViewModel(item: testItem)
    }
    
    func testGetFriendNameForLoan() {
        let friend = friendVM.friends[0]
        let item = itemVM.items[0]
        
        itemDetailVM.lendItem(to: friend, loanDate: Date(), returnDate: nil)
        
        let loans = itemDetailVM.loans
        XCTAssertGreaterThan(loans.count, 0)
        
        let loan = loans[0]
        let friendName = itemDetailVM.getFriendName(for: loan)
        
        XCTAssertEqual(friendName, friend.name)
    }
    
    func testReturnBorrowedItem() {
        let friend = friendVM.friends[0]
        let itemId = itemDetailVM.item.id
        
        // Emprestar
        itemDetailVM.lendItem(to: friend, loanDate: Date(), returnDate: nil)
        let activeLoans = itemDetailVM.loans.filter { $0.returnDate == nil }
        
        XCTAssertGreaterThan(activeLoans.count, 0)
        
        // Devolver
        let loanToReturn = activeLoans[0]
        itemDetailVM.returnItem(loan: loanToReturn)
        
        // Reload items to get updates from repository
        itemVM.loadItems()
        
        // Verificar que loan tem returnDate
        let allLoans = itemDetailVM.loans
        let returnedLoan = allLoans.first { $0.id == loanToReturn.id }
        XCTAssertNotNil(returnedLoan?.returnDate)
        
        // Verificar status mudou para available
        let itemAfterReturn = itemVM.items.first { $0.id == itemId }
        XCTAssertEqual(itemAfterReturn?.status, .available)
    }
}

