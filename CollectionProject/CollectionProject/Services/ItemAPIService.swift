import Foundation

/// Communicates with the real REST API for items.
/// Replace the TODO comments with actual endpoint paths when the API is ready.
final class ItemAPIService: ItemServiceProtocol {

    private struct ListResponse<T: Decodable>: Decodable {
        let data: [T]
    }

    private struct SingleResponse<T: Decodable>: Decodable {
        let data: T
    }

    private struct ItemDTO: Decodable {
        let id: Int
        let title: String
        let category: Category
        let platform: String?
        let coverImageUrl: String?
        let notes: String?
        let status: ItemStatus
    }

    private struct ItemPayload: Encodable {
        let item: ItemAttributes
    }

    private struct ItemAttributes: Encodable {
        let title: String
        let category: Category
        let platform: String?
        let notes: String?
        let coverImageUrl: String?
        let status: ItemStatus

        private enum CodingKeys: String, CodingKey {
            case title
            case category
            case platform
            case notes
            case coverImageUrl
            case status
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(title, forKey: .title)
            try container.encode(category, forKey: .category)

            // Encode explicit null so API can clear previously persisted values on update.
            if let platform {
                try container.encode(platform, forKey: .platform)
            } else {
                try container.encodeNil(forKey: .platform)
            }

            if let notes {
                try container.encode(notes, forKey: .notes)
            } else {
                try container.encodeNil(forKey: .notes)
            }

            if let coverImageUrl {
                try container.encode(coverImageUrl, forKey: .coverImageUrl)
            } else {
                try container.encodeNil(forKey: .coverImageUrl)
            }

            try container.encode(status, forKey: .status)
        }
    }

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func getAll() async throws -> [Item] {
        let response: ListResponse<ItemDTO> = try await client.get("items")
        return response.data.map(mapToDomain)
    }

    func get(by id: UUID) async throws -> Item? {
        guard let apiId = APIIDBridge.apiId(from: id) else { return nil }
        let response: SingleResponse<ItemDTO> = try await client.get("items/\(apiId)")
        return mapToDomain(response.data)
    }

    func add(_ item: Item) async throws {
        let payload = ItemPayload(item: mapToAttributes(item))
        let _: SingleResponse<ItemDTO> = try await client.post("items", body: payload)
    }

    func update(_ item: Item) async throws {
        guard let apiId = APIIDBridge.apiId(from: item.id) else { throw ServiceError.notFound }
        let payload = ItemPayload(item: mapToAttributes(item))
        let _: SingleResponse<ItemDTO> = try await client.put("items/\(apiId)", body: payload)
    }

    func delete(_ item: Item) async throws {
        guard let apiId = APIIDBridge.apiId(from: item.id) else { throw ServiceError.notFound }
        try await client.delete("items/\(apiId)")
    }

    private func mapToDomain(_ dto: ItemDTO) -> Item {
        var item = Item(
            title: dto.title,
            category: dto.category,
            platform: dto.platform,
            coverImage: dto.coverImageUrl,
            notes: dto.notes,
            status: dto.status
        )
        item.id = APIIDBridge.uuid(from: dto.id)
        return item
    }

    private func mapToAttributes(_ item: Item) -> ItemAttributes {
        ItemAttributes(
            title: item.title,
            category: item.category,
            platform: item.platform,
            notes: item.notes,
            coverImageUrl: item.coverImage,
            status: item.status
        )
    }
}
