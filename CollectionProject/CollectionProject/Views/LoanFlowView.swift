import SwiftUI

struct LoanFlowView: View {
    let item: Item
    @ObservedObject var viewModel: ItemDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedFriend: Friend?
    @State private var loanDate = Date()
    @State private var returnDate: Date?
    @State private var returnDateValue = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Picker(NSLocalizedString("Select Friend", comment: "Picker label"), selection: $selectedFriend) {
                    Text(NSLocalizedString("Select Friend", comment: "Picker placeholder")).tag(Friend?.none)
                    ForEach(AppDependencies.friendRepository.getAll()) { friend in
                        Text(friend.name).tag(friend as Friend?)
                    }
                }
                
                DatePicker(NSLocalizedString("Loan Date", comment: "Date picker label"), selection: $loanDate, displayedComponents: .date)
                
                Toggle(NSLocalizedString("Has Return Date", comment: "Toggle label"), isOn: Binding(
                    get: { returnDate != nil },
                    set: { if !$0 { returnDate = nil } else { returnDate = returnDateValue } }
                ))
                
                if returnDate != nil {
                    DatePicker(NSLocalizedString("Return Date", comment: "Date picker label"), selection: $returnDateValue, displayedComponents: .date)
                        .onChange(of: returnDateValue) { returnDate = $0 }
                }
            }
            .navigationTitle("Lend \(item.title)")
            .navigationBarItems(trailing: Button(NSLocalizedString("Lend", comment: "Button")) {
                if let friend = selectedFriend {
                    viewModel.lendItem(to: friend, loanDate: loanDate, returnDate: returnDate)
                    dismiss()
                }
            })
        }
    }
}