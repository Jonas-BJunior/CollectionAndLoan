import Foundation
import Combine

@MainActor
class FriendDetailViewModel: ObservableObject {
    @Published var activeLoans: [Loan] = []
    @Published var loanedItems: [UUID: Item] = [:]
    @Published var errorMessage: String? = nil

    private let friend: Friend
    private let loanService: LoanServiceProtocol
    private let itemService: ItemServiceProtocol

    init(friend: Friend,
         loanService: LoanServiceProtocol = AppDependencies.loanService,
         itemService: ItemServiceProtocol = AppDependencies.itemService) {
        self.friend = friend
        self.loanService = loanService
        self.itemService = itemService
        loadActiveLoans()
    }

    func loadActiveLoans() {
        Task {
            do {
                let loans = try await loanService.getLoansByFriend(for: friend.id)
                activeLoans = loans.filter { $0.returnDate == nil }
                try await loadItems(for: activeLoans)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func loadItems(for loans: [Loan]) async throws {
        for loan in loans {
            if let item = try await itemService.get(by: loan.itemId) {
                loanedItems[loan.itemId] = item
            }
        }
    }

    func getItem(for loan: Loan) -> Item? {
        return loanedItems[loan.itemId]
    }
}
