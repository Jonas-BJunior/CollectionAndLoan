import Foundation

/// Communicates with the real REST API for friends.
/// Replace the TODO comments with actual endpoint paths when the API is ready.
final class FriendAPIService: FriendServiceProtocol {

    private struct ListResponse<T: Decodable>: Decodable {
        let data: [T]
    }

    private struct SingleResponse<T: Decodable>: Decodable {
        let data: T
    }

    private struct FriendDTO: Decodable {
        let id: Int
        let name: String
        let email: String?
    }

    private struct FriendPayload: Encodable {
        let friend: FriendAttributes
    }

    private struct FriendAttributes: Encodable {
        let name: String
        let email: String?
        let phone: String?
    }

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func getAll() async throws -> [Friend] {
        let response: ListResponse<FriendDTO> = try await client.get("friends")
        return response.data.map(mapToDomain)
    }

    func get(by id: UUID) async throws -> Friend? {
        guard let apiId = APIIDBridge.apiId(from: id) else { return nil }
        let response: SingleResponse<FriendDTO> = try await client.get("friends/\(apiId)")
        return mapToDomain(response.data)
    }

    func add(_ friend: Friend) async throws {
        let payload = FriendPayload(friend: mapToAttributes(friend))
        let _: SingleResponse<FriendDTO> = try await client.post("friends", body: payload)
    }

    func update(_ friend: Friend) async throws {
        guard let apiId = APIIDBridge.apiId(from: friend.id) else { throw ServiceError.notFound }
        let payload = FriendPayload(friend: mapToAttributes(friend))
        let _: SingleResponse<FriendDTO> = try await client.put("friends/\(apiId)", body: payload)
    }

    func remove(_ friend: Friend) async throws {
        guard let apiId = APIIDBridge.apiId(from: friend.id) else { throw ServiceError.notFound }
        try await client.delete("friends/\(apiId)")
    }

    private func mapToDomain(_ dto: FriendDTO) -> Friend {
        var friend = Friend(name: dto.name, email: dto.email)
        friend.id = APIIDBridge.uuid(from: dto.id)
        return friend
    }

    private func mapToAttributes(_ friend: Friend) -> FriendAttributes {
        FriendAttributes(name: friend.name, email: friend.email, phone: nil)
    }
}
