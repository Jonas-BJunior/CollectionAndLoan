import Foundation
import Combine

@MainActor
class ItemDetailViewModel: ObservableObject {
    @Published var item: Item
    @Published var loans: [Loan] = []
    @Published var itemDeleted = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let itemService: ItemServiceProtocol
    private let loanService: LoanServiceProtocol
    private let friendService: FriendServiceProtocol

    init(item: Item,
         itemService: ItemServiceProtocol = AppDependencies.itemService,
         loanService: LoanServiceProtocol = AppDependencies.loanService,
         friendService: FriendServiceProtocol = AppDependencies.friendService) {
        self.item = item
        self.itemService = itemService
        self.loanService = loanService
        self.friendService = friendService
        loadLoans()
    }

    func loadLoans() {
        Task {
            do {
                loans = try await loanService.getLoans(for: item.id)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func lendItem(to friend: Friend, loanDate: Date, returnDate: Date?) {
        Task {
            do {
                let loan = Loan(itemId: item.id, friendId: friend.id, loanDate: loanDate, returnDate: returnDate)
                try await loanService.add(loan)
                item.status = .lent
                try await itemService.update(item)
                if let updated = try await itemService.get(by: item.id) {
                    item = updated
                }
                loans = try await loanService.getLoans(for: item.id)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func returnItem(loan: Loan) {
        Task {
            do {
                var updatedLoan = loan
                updatedLoan.returnDate = Date()
                try await loanService.update(updatedLoan)
                item.status = .available
                try await itemService.update(item)
                loans = try await loanService.getLoans(for: item.id)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func getFriendName(for loan: Loan) -> String {
        // Synchronous lookup from a locally cached list is not possible with async protocol.
        // Use getFriendNameAsync(for:) for a proper async call, or cache friends in the ViewModel if needed.
        return "Loading..."
    }

    func getFriendNameAsync(for loan: Loan) async -> String {
        do {
            return try await friendService.get(by: loan.friendId)?.name ?? "Unknown"
        } catch {
            return "Unknown"
        }
    }
}
