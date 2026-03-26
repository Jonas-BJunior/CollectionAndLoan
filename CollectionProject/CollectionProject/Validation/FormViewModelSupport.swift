import Foundation
import Combine

@MainActor
protocol FormStateValidating: ObservableObject {
    var didAttemptSave: Bool { get set }
    var hasAnyUserInput: Bool { get }
    var isFormValid: Bool { get }
}

extension FormStateValidating {
    var shouldShowValidation: Bool {
        didAttemptSave || hasAnyUserInput
    }
}

enum FormValueNormalizer {
    static func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func nilIfEmpty(_ value: String) -> String? {
        let trimmed = trimmed(value)
        return trimmed.isEmpty ? nil : trimmed
    }
}
