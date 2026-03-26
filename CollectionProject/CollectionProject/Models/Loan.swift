import Foundation

struct Loan: Identifiable, Codable {
    var id: UUID = UUID()
    var itemId: UUID
    var friendId: UUID
    var loanDate: Date
    // Legacy field name kept for expected return date compatibility in app flows/tests.
    var returnDate: Date?
    var returnedAt: Date?
}