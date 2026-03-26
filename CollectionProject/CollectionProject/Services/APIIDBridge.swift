import Foundation

enum APIIDBridge {
    static func uuid(from apiId: Int) -> UUID {
        let hex = String(format: "%012llx", apiId)
        let uuidString = "00000000-0000-0000-0000-\(hex)"
        return UUID(uuidString: uuidString) ?? UUID()
    }

    static func apiId(from uuid: UUID) -> Int? {
        let compact = uuid.uuidString.lowercased().replacingOccurrences(of: "-", with: "")
        guard compact.hasPrefix(String(repeating: "0", count: 20)) else { return nil }

        let hex = String(compact.suffix(12))
        guard let value = Int(hex, radix: 16) else { return nil }
        return value
    }
}
