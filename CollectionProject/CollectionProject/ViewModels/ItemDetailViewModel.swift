import Foundation
import Combine

class ItemDetailViewModel: ObservableObject {
    @Published var item: Item
    @Published var loans: [Loan] = []
    
    private let itemRepository: ItemRepository
    private let loanRepository: LoanRepository
    private let friendRepository: FriendRepository
    
    init(item: Item) {
        self.item = item
        self.itemRepository = AppDependencies.itemRepository
        self.loanRepository = AppDependencies.loanRepository
        self.friendRepository = AppDependencies.friendRepository
        loadLoans()
    }
    
    func loadLoans() {
        loans = loanRepository.getLoans(for: item.id)
    }
    
    func lendItem(to friend: Friend, loanDate: Date, returnDate: Date?) {
        let loan = Loan(itemId: item.id, friendId: friend.id, loanDate: loanDate, returnDate: returnDate)
        loanRepository.add(loan)
        item.status = .lent
        itemRepository.update(item)
        self.item = itemRepository.get(by: item.id) ?? item
        loadLoans()
    }
    
    func returnItem(loan: Loan) {
        var updatedLoan = loan
        updatedLoan.returnDate = Date()
        loanRepository.update(updatedLoan)
        item.status = .available
        itemRepository.update(item)
        loadLoans()
    }
    
    func getFriendName(for loan: Loan) -> String {
        return friendRepository.get(by: loan.friendId)?.name ?? "Unknown"
    }
}