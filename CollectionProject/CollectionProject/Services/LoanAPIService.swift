import Foundation

/// Communicates with the real REST API for loans.
final class LoanAPIService: LoanServiceProtocol {

    private struct ListResponse<T: Decodable>: Decodable {
        let data: [T]
    }

    private struct SingleResponse<T: Decodable>: Decodable {
        let data: T
    }

    private struct LoanDTO: Decodable {
        let id: Int
        let itemId: Int
        let friendId: Int
        let loanDate: Date
        let expectedReturnDate: Date?
        let returnedAt: Date?
    }

    private struct LoanPayload: Encodable {
        let loan: LoanAttributes
    }

    private struct LoanAttributes: Encodable {
        let itemId: Int
        let friendId: Int
        let loanDate: String
        let expectedReturnDate: String?
    }

    private struct LoanUpdatePayload: Encodable {
        let loan: LoanUpdateAttributes
    }

    private struct LoanUpdateAttributes: Encodable {
        let expectedReturnDate: String?
    }

    private struct EmptyBody: Encodable {}

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func getAll() async throws -> [Loan] {
        let response: ListResponse<LoanDTO> = try await client.get("loans")
        return response.data.map(mapToDomain)
    }

    func get(by id: UUID) async throws -> Loan? {
        guard let apiId = APIIDBridge.apiId(from: id) else { return nil }
        let response: SingleResponse<LoanDTO> = try await client.get("loans/\(apiId)")
        return mapToDomain(response.data)
    }

    func getLoans(for itemId: UUID) async throws -> [Loan] {
        guard let apiId = APIIDBridge.apiId(from: itemId) else { return [] }
        let response: ListResponse<LoanDTO> = try await client.get("loans?item_id=\(apiId)")
        return response.data.map(mapToDomain)
    }

    func getLoansByFriend(for friendId: UUID) async throws -> [Loan] {
        guard let apiId = APIIDBridge.apiId(from: friendId) else { return [] }
        let response: ListResponse<LoanDTO> = try await client.get("loans?friend_id=\(apiId)")
        return response.data.map(mapToDomain)
    }

    func add(_ loan: Loan) async throws {
        guard let itemApiId = APIIDBridge.apiId(from: loan.itemId),
              let friendApiId = APIIDBridge.apiId(from: loan.friendId) else {
            throw ServiceError.notFound
        }

        let payload = LoanPayload(
            loan: LoanAttributes(
                itemId: itemApiId,
                friendId: friendApiId,
                loanDate: formatDateOnly(loan.loanDate),
                expectedReturnDate: loan.returnDate.map(formatDateOnly)
            )
        )

        let _: SingleResponse<LoanDTO> = try await client.post("loans", body: payload)
    }

    func update(_ loan: Loan) async throws {
        guard let loanApiId = APIIDBridge.apiId(from: loan.id) else {
            throw ServiceError.notFound
        }

        if loan.returnDate != nil {
            let _: SingleResponse<LoanDTO> = try await client.post("loans/\(loanApiId)/return_item", body: EmptyBody())
        } else {
            let payload = LoanUpdatePayload(
                loan: LoanUpdateAttributes(expectedReturnDate: nil)
            )
            let _: SingleResponse<LoanDTO> = try await client.put("loans/\(loanApiId)", body: payload)
        }
    }

    func delete(_ loan: Loan) async throws {
        guard let loanApiId = APIIDBridge.apiId(from: loan.id) else {
            throw ServiceError.notFound
        }

        try await client.delete("loans/\(loanApiId)")
    }

    private func mapToDomain(_ dto: LoanDTO) -> Loan {
        var loan = Loan(
            itemId: APIIDBridge.uuid(from: dto.itemId),
            friendId: APIIDBridge.uuid(from: dto.friendId),
            loanDate: dto.loanDate,
            returnDate: dto.returnedAt ?? dto.expectedReturnDate
        )
        loan.id = APIIDBridge.uuid(from: dto.id)
        return loan
    }

    private func formatDateOnly(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
