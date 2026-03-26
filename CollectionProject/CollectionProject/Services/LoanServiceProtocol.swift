import Foundation

protocol LoanServiceProtocol {
    func getAll() async throws -> [Loan]
    func get(by id: UUID) async throws -> Loan?
    func getLoans(for itemId: UUID) async throws -> [Loan]
    func getLoansByFriend(for friendId: UUID) async throws -> [Loan]
    func add(_ loan: Loan) async throws
    func update(_ loan: Loan) async throws
    func delete(_ loan: Loan) async throws
}
