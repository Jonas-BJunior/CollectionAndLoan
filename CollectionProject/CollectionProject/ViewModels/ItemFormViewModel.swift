import Foundation
import Combine

@MainActor
final class ItemFormViewModel: FormStateValidating {
    @Published var title: String
    @Published var category: Category
    @Published var platform: String
    @Published var notes: String
    @Published var didAttemptSave = false

    init(item: Item? = nil) {
        self.title = item?.title ?? ""
        self.category = item?.category ?? .game
        self.platform = item?.platform ?? ""
        self.notes = item?.notes ?? ""
    }

    var hasAnyUserInput: Bool {
        !title.isEmpty || !platform.isEmpty || !notes.isEmpty
    }

    var titleErrorMessage: String? {
        ItemFormValidator.validateTitle(title)
    }

    var isFormValid: Bool {
        titleErrorMessage == nil
    }

    var normalizedTitle: String {
        FormValueNormalizer.trimmed(title)
    }

    var normalizedPlatform: String? {
        FormValueNormalizer.nilIfEmpty(platform)
    }

    var normalizedNotes: String? {
        FormValueNormalizer.nilIfEmpty(notes)
    }
}
