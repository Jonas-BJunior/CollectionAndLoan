import Foundation
import Combine

@MainActor
class ItemDetailViewModel: ObservableObject {
    @Published var item: Item
    @Published var loans: [Loan] = []
    @Published var itemDeleted = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published private var friendNames: [UUID: String] = [:]

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
                let fetchedLoans = try await loanService.getLoans(for: item.id)
                loans = fetchedLoans
                await preloadFriendNames(for: fetchedLoans)
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
                let fetchedLoans = try await loanService.getLoans(for: item.id)
                loans = fetchedLoans
                await preloadFriendNames(for: fetchedLoans)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func returnItem(loan: Loan) {
        Task {
            do {
                var updatedLoan = loan
                updatedLoan.returnedAt = Date()
                try await loanService.update(updatedLoan)
                item.status = .available
                try await itemService.update(item)
                let fetchedLoans = try await loanService.getLoans(for: item.id)
                loans = fetchedLoans
                await preloadFriendNames(for: fetchedLoans)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func getFriendName(for loan: Loan) -> String {
        return friendNames[loan.friendId] ?? "Unknown"
    }

    func getFriendNameAsync(for loan: Loan) async -> String {
        do {
            return try await friendService.get(by: loan.friendId)?.name ?? "Unknown"
        } catch {
            return "Unknown"
        }
    }

    private func preloadFriendNames(for loans: [Loan]) async {
        let uniqueFriendIds = Set(loans.map { $0.friendId })
        var updatedNames = friendNames

        for friendId in uniqueFriendIds where updatedNames[friendId] == nil {
            do {
                let friend = try await friendService.get(by: friendId)
                updatedNames[friendId] = friend?.name ?? "Unknown"
            } catch {
                updatedNames[friendId] = "Unknown"
            }
        }

        friendNames = updatedNames
    }
}
