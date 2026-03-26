import Foundation
import Combine

class FriendDetailViewModel: ObservableObject {
    @Published var activeLoans: [Loan] = []
    
    private let friend: Friend
    private let loanRepository: LoanRepository
    private let itemRepository: ItemRepository
    
    init(friend: Friend) {
        self.friend = friend
        self.loanRepository = AppDependencies.loanRepository
        self.itemRepository = AppDependencies.itemRepository
        loadActiveLoans()
    }
    
    func loadActiveLoans() {
        activeLoans = loanRepository.getLoansByFriend(for: friend.id).filter { $0.returnDate == nil }
    }
    
    func getItem(for loan: Loan) -> Item? {
        return itemRepository.get(by: loan.itemId)
    }
}