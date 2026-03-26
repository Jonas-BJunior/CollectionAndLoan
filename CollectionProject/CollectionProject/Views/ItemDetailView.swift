import SwiftUI

struct ItemDetailView: View {
    let item: Item
    @StateObject private var viewModel: ItemDetailViewModel
    @State private var showingLend = false
    
    init(item: Item) {
        self.item = item
        _viewModel = StateObject(wrappedValue: ItemDetailViewModel(item: item))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(12)
                
                Text(item.title)
                    .font(.largeTitle)
                    .bold()
                
                Text(item.category.rawValue.capitalized)
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                if let platform = item.platform {
                    Text("Platform: \(platform)")
                        .font(.body)
                }
                
                if let notes = item.notes {
                    Text("Notes: \(notes)")
                        .font(.body)
                }
                
                Text("Status: \(item.status.rawValue.capitalized)")
                    .font(.headline)
                    .foregroundColor(item.status == .available ? .green : .red)
                
                if item.status == .available {
                    Button("Lend Item") {
                        showingLend = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                } else {
                    if let currentLoan = viewModel.loans.first(where: { $0.returnDate == nil }) {
                        Button("Mark as Returned") {
                            viewModel.returnItem(loan: currentLoan)
                        }
                        .buttonStyle(.bordered)
                        .padding(.top)
                    }
                }
                
                if !viewModel.loans.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Loan History")
                            .font(.headline)
                            .padding(.top)
                        
                        ForEach(viewModel.loans) { loan in
                            HStack {
                                Text(viewModel.getFriendName(for: loan))
                                Spacer()
                                Text(loan.loanDate, style: .date)
                                if let returnDate = loan.returnDate {
                                    Text(" - \(returnDate, style: .date)")
                                } else {
                                    Text(" - Ongoing")
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(item.title)
        .sheet(isPresented: $showingLend) {
            LoanFlowView(item: item, viewModel: viewModel)
        }
    }
}