import SwiftUI

struct LoanFlowView: View {
    let item: Item
    @ObservedObject var viewModel: ItemDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedFriend: Friend?
    @State private var loanDate = Date()
    @State private var returnDate: Date?
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Friend", selection: $selectedFriend) {
                    Text("Select Friend").tag(Friend?.none)
                    ForEach(AppDependencies.friendRepository.getAll()) { friend in
                        Text(friend.name).tag(friend as Friend?)
                    }
                }
                
                DatePicker("Loan Date", selection: $loanDate, displayedComponents: .date)
                
                Toggle("Has Return Date", isOn: Binding(
                    get: { returnDate != nil },
                    set: { if !$0 { returnDate = nil } else { returnDate = Date() } }
                ))
                
                if returnDate != nil {
                    DatePicker("Return Date", selection: Binding($returnDate)!, displayedComponents: .date)
                }
            }
            .navigationTitle("Lend \(item.title)")
            .navigationBarItems(trailing: Button("Lend") {
                if let friend = selectedFriend {
                    viewModel.lendItem(to: friend, loanDate: loanDate, returnDate: returnDate)
                    dismiss()
                }
            })
        }
    }
}