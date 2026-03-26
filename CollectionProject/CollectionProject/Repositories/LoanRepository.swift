import Foundation

class LoanRepository {
    private var loans: [Loan] = []
    
    func getAll() -> [Loan] {
        return loans
    }
    
    func add(_ loan: Loan) {
        loans.append(loan)
    }
    
    func update(_ loan: Loan) {
        if let index = loans.firstIndex(where: { $0.id == loan.id }) {
            loans[index] = loan
        }
    }
    
    func get(by id: UUID) -> Loan? {
        return loans.first { $0.id == id }
    }
    
    func getLoans(for itemId: UUID) -> [Loan] {
        return loans.filter { $0.itemId == itemId }
    }
    
    func getLoansByFriend(for friendId: UUID) -> [Loan] {
        return loans.filter { $0.friendId == friendId }
    }
    
    func delete(_ loan: Loan) {
        loans.removeAll { $0.id == loan.id }
    }
}