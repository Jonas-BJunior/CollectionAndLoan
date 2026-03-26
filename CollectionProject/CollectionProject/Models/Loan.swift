import Foundation

struct Loan: Identifiable {
    let id = UUID()
    var itemId: UUID
    var friendId: UUID
    var loanDate: Date
    var returnDate: Date?
}