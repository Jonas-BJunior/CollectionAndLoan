import Foundation

@MainActor
class AppDependencies {

    // MARK: - Feature flag
    // Set to `false` when the real API is ready.
    static let useMockServices: Bool = true

    // MARK: - Services
    static let itemService: ItemServiceProtocol = useMockServices
        ? MockItemService()
        : ItemAPIService()

    static let friendService: FriendServiceProtocol = useMockServices
        ? MockFriendService()
        : FriendAPIService()

    static let loanService: LoanServiceProtocol = useMockServices
        ? MockLoanService()
        : LoanAPIService()
}
