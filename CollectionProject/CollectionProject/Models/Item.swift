import Foundation

struct Item: Identifiable {
    let id = UUID()
    var title: String
    var category: Category
    var platform: String?
    var coverImage: String? // Placeholder for image path or URL
    var notes: String?
    var status: ItemStatus = .available
}

enum Category: String, CaseIterable, Identifiable {
    case game, book, movie, boardgame, other
    
    var id: String { self.rawValue }
}

enum ItemStatus: String {
    case available, lent
}