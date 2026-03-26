import Foundation

struct Friend: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var email: String?
}