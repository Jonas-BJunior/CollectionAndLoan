import Foundation

struct Friend: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var name: String
    var email: String?
}