import Foundation

struct Loan: Identifiable, Codable {
    var id: UUID = UUID()
    var itemId: UUID
    var friendId: UUID
    var loanDate: Date
    var returnDate: Date?
}