import Foundation

/// Communicates with the real REST API for loans.
/// Replace the TODO comments with actual endpoint paths when the API is ready.
final class LoanAPIService: LoanServiceProtocol {

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func getAll() async throws -> [Loan] {
        // TODO: confirm endpoint path with API team
        return try await client.get("/loans")
    }

    func get(by id: UUID) async throws -> Loan? {
        // TODO: confirm endpoint path with API team
        return try await client.get("/loans/\(id.uuidString)")
    }

    func getLoans(for itemId: UUID) async throws -> [Loan] {
        // TODO: confirm endpoint path with API team
        return try await client.get("/loans?itemId=\(itemId.uuidString)")
    }

    func getLoansByFriend(for friendId: UUID) async throws -> [Loan] {
        // TODO: confirm endpoint path with API team
        return try await client.get("/loans?friendId=\(friendId.uuidString)")
    }

    func add(_ loan: Loan) async throws {
        // TODO: confirm endpoint path with API team
        let _: Loan = try await client.post("/loans", body: loan)
    }

    func update(_ loan: Loan) async throws {
        // TODO: confirm endpoint path with API team
        let _: Loan = try await client.put("/loans/\(loan.id.uuidString)", body: loan)
    }

    func delete(_ loan: Loan) async throws {
        // TODO: confirm endpoint path with API team
        try await client.delete("/loans/\(loan.id.uuidString)")
    }
}
