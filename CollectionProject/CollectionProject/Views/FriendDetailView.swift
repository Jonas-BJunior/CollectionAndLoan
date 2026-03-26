import SwiftUI

struct FriendDetailView: View {
    let friend: Friend
    @StateObject private var viewModel: FriendDetailViewModel
    @State private var showingEdit = false
    
    init(friend: Friend) {
        self.friend = friend
        _viewModel = StateObject(wrappedValue: FriendDetailViewModel(friend: friend))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(friend.name)
                        .font(.largeTitle)
                        .bold()
                    
                    if let email = friend.email {
                        Text(email)
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                
                if viewModel.activeLoans.isEmpty {
                    Text("No items currently lent to \(friend.name).")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.top)
                } else {
                    VStack(alignment: .leading) {
                        Text("Lent Items")
                            .font(.headline)
                            .padding(.top)
                        
                        ForEach(viewModel.activeLoans) { loan in
                            if let item = viewModel.getItem(for: loan) {
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.headline)
                                    Text("Lent on: \(loan.loanDate, style: .date)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    if let returnDate = loan.returnDate {
                                        Text("Return by: \(returnDate, style: .date)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text("Ongoing loan")
                                            .font(.subheadline)
                                            .foregroundColor(.orange)
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarItems(trailing: Button("Edit") {
            showingEdit = true
        })
        .onAppear {
            viewModel.loadActiveLoans()
        }
        .sheet(isPresented: $showingEdit) {
            AddFriendView(friend: friend)
        }
    }
}