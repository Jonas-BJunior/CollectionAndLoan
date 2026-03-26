import Foundation

struct FriendFormValidator {

    static func validateName(_ rawName: String) -> String? {
        let trimmedName = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty {
            return NSLocalizedString("Name is required.", comment: "Friend validation")
        }

        let letterCount = trimmedName.unicodeScalars.filter { CharacterSet.letters.contains($0) }.count
        if letterCount < 3 {
            return NSLocalizedString("Name must contain at least 3 letters.", comment: "Friend validation")
        }

        return nil
    }

    static func validateEmail(_ rawEmail: String) -> String? {
        let trimmedEmail = rawEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty else { return nil }

        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let isValidEmail = trimmedEmail.range(of: pattern, options: .regularExpression) != nil
        return isValidEmail ? nil : NSLocalizedString("Enter a valid email address.", comment: "Friend validation")
    }
}
