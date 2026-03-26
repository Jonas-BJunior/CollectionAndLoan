import Foundation

/// In-memory mock implementation of LoanServiceProtocol.
/// Use while the real API is not ready. Starts empty (loans are created at runtime).
final class MockLoanService: LoanServiceProtocol {

    private var loans: [Loan] = []

    func getAll() async throws -> [Loan] {
        return loans
    }

    func get(by id: UUID) async throws -> Loan? {
        return loans.first { $0.id == id }
    }

    func getLoans(for itemId: UUID) async throws -> [Loan] {
        return loans.filter { $0.itemId == itemId }
    }

    func getLoansByFriend(for friendId: UUID) async throws -> [Loan] {
        return loans.filter { $0.friendId == friendId }
    }

    func add(_ loan: Loan) async throws {
        loans.append(loan)
    }

    func update(_ loan: Loan) async throws {
        guard let index = loans.firstIndex(where: { $0.id == loan.id }) else { return }
        loans[index] = loan
    }

    func delete(_ loan: Loan) async throws {
        loans.removeAll { $0.id == loan.id }
    }

    // MARK: - Test helper
    func reset() {
        loans = []
    }
}
