import XCTest

class CollectionProjectUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLendItemToFriend() throws {
        let app = XCUIApplication()
        app.launch()

        // Navigate to Collection tab (first tab)
        let collectionTab = app.tabBars.buttons.element(boundBy: 0)
        XCTAssertTrue(collectionTab.exists)
        collectionTab.tap()

        // Select the first item in the collection
        let itemButtons = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'item_'"))
        let firstItem = itemButtons.firstMatch
        XCTAssertTrue(firstItem.exists, "First item should exist")
        firstItem.tap()

        // In ItemDetailView, tap the "Lend Item" button
        let lendButton = app.buttons["lendItemButton"]
        XCTAssertTrue(lendButton.exists, "Lend Item button should exist")
        lendButton.tap()

        // Verify the loan flow sheet opened by checking for the lend button
        let confirmLendButton = app.buttons["lendButton"]
        XCTAssertTrue(confirmLendButton.waitForExistence(timeout: 5), "Lend button should exist in the sheet")

        // Select a friend from the picker using accessibility identifier only.
        let friendPicker = app.descendants(matching: .any)["friendPicker"]
        XCTAssertTrue(friendPicker.waitForExistence(timeout: 5), "Friend picker should exist")
        friendPicker.tap()

        // Wait for picker options and select "Alice"
        let aliceOption = app.buttons["Alice"]
        if aliceOption.waitForExistence(timeout: 3) {
            aliceOption.tap()
        } else {
            // Fallback: try static text
            let aliceStatic = app.staticTexts["Alice"]
            if aliceStatic.waitForExistence(timeout: 3) {
                aliceStatic.tap()
            }
        }

        // Now tap the lend button to complete the loan
        confirmLendButton.tap()

        // Verify we are back to ItemDetailView
        let itemDetailNavBar = app.navigationBars["The Witcher 3"]
        XCTAssertTrue(itemDetailNavBar.waitForExistence(timeout: 5), "Should be back to item detail")
    }

    func testNavigateToFriendsTab() throws {
        let app = XCUIApplication()
        app.launch()

        // Navigate to Friends tab (second tab)
        let friendsTab = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(friendsTab.exists)
        friendsTab.tap()

        // Verify Friends view is displayed by checking for the add-friend element identifier
        let addFriendButton = app.buttons["addFriendButton"]
        XCTAssertTrue(addFriendButton.waitForExistence(timeout: 5), "Add Friend button should exist in Friends view")

        // Check if friends are displayed (at least one friend should be visible)
        let friendElements = app.staticTexts.matching(NSPredicate(format: "label IN %@", ["Alice", "Bob"]))
        XCTAssertTrue(friendElements.count > 0, "At least one friend should be displayed")
    }
}
