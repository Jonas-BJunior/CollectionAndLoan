import XCTest
@testable import CollectionProject

final class FriendFormValidatorTests: XCTestCase {

    func testValidateNameEmptyReturnsError() {
        XCTAssertNotNil(FriendFormValidator.validateName(""))
        XCTAssertNotNil(FriendFormValidator.validateName("   "))
    }

    func testValidateNameWithLessThanThreeLettersReturnsError() {
        XCTAssertNotNil(FriendFormValidator.validateName("Al"))
        XCTAssertNotNil(FriendFormValidator.validateName("A1"))
    }

    func testValidateNameWithThreeLettersOrMoreIsValid() {
        XCTAssertNil(FriendFormValidator.validateName("Ana"))
        XCTAssertNil(FriendFormValidator.validateName("Joao Silva"))
    }

    func testValidateEmailEmptyIsValid() {
        XCTAssertNil(FriendFormValidator.validateEmail(""))
        XCTAssertNil(FriendFormValidator.validateEmail("   "))
    }

    func testValidateEmailInvalidReturnsError() {
        XCTAssertNotNil(FriendFormValidator.validateEmail("not-an-email"))
        XCTAssertNotNil(FriendFormValidator.validateEmail("user@"))
        XCTAssertNotNil(FriendFormValidator.validateEmail("@domain.com"))
    }

    func testValidateEmailValidReturnsNil() {
        XCTAssertNil(FriendFormValidator.validateEmail("user@example.com"))
        XCTAssertNil(FriendFormValidator.validateEmail("first.last+tag@domain.com"))
    }
}
