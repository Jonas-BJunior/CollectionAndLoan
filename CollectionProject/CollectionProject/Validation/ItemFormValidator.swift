import Foundation

struct ItemFormValidator {

    static func validateTitle(_ rawTitle: String) -> String? {
        let trimmedTitle = rawTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTitle.isEmpty {
            return NSLocalizedString("Title is required.", comment: "Item validation")
        }
        return nil
    }
}
