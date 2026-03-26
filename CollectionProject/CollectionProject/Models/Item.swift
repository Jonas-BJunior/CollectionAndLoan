import Foundation

struct Item: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var category: Category
    var platform: String?
    var coverImage: String?
    var notes: String?
    var status: ItemStatus = .available
}

enum Category: String, CaseIterable, Identifiable, Codable {
    case game, book, movie, boardgame, other

    var id: String { self.rawValue }
}

enum ItemStatus: String, Codable {
    case available, lent
}