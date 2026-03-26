import SwiftUI

struct LoanFlowView: View {
    let item: Item
    @ObservedObject var viewModel: ItemDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedFriend: Friend?
    @State private var loanDate = Date()
    @State private var returnDate: Date?
    @State private var returnDateValue = Date()
    @State private var friends: [Friend] = []

    var body: some View {
        NavigationView {
            Form {
                Picker(NSLocalizedString("Select Friend", comment: "Picker label"), selection: $selectedFriend) {
                    Text(NSLocalizedString("Select Friend", comment: "Picker placeholder")).tag(Friend?.none)
                    ForEach(friends) { friend in
                        Text(friend.name).tag(friend as Friend?)
                    }
                }
                .accessibilityIdentifier("friendPicker")
                
                DatePicker(NSLocalizedString("Loan Date", comment: "Date picker label"), selection: $loanDate, displayedComponents: .date)
                    .accessibilityIdentifier("loanDatePicker")
                
                Toggle(NSLocalizedString("Has Return Date", comment: "Toggle label"), isOn: Binding(
                    get: { returnDate != nil },
                    set: { if !$0 { returnDate = nil } else { returnDate = returnDateValue } }
                ))
                .accessibilityIdentifier("hasReturnDateToggle")
                
                if returnDate != nil {
                    DatePicker(NSLocalizedString("Return Date", comment: "Date picker label"), selection: $returnDateValue, displayedComponents: .date)
                        .onChange(of: returnDateValue) { _, newValue in
                            returnDate = newValue
                        }
                }
            }
            .navigationTitle("Lend \(item.title)")
            .task {
                friends = (try? await AppDependencies.friendService.getAll()) ?? []
            }
            .navigationBarItems(trailing: Button(NSLocalizedString("Lend", comment: "Button")) {
                if let friend = selectedFriend {
                    viewModel.lendItem(to: friend, loanDate: loanDate, returnDate: returnDate)
                    dismiss()
                }
            }
            .accessibilityIdentifier("lendButton"))
        }
    }
}