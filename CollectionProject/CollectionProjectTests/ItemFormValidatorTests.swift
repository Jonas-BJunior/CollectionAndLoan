import XCTest
@testable import CollectionProject

final class ItemFormValidatorTests: XCTestCase {

    func testValidateTitleEmptyReturnsError() {
        XCTAssertNotNil(ItemFormValidator.validateTitle(""))
        XCTAssertNotNil(ItemFormValidator.validateTitle("   "))
    }

    func testValidateTitleValidReturnsNil() {
        XCTAssertNil(ItemFormValidator.validateTitle("Sonic"))
        XCTAssertNil(ItemFormValidator.validateTitle("  Batman  "))
    }
}
