import SwiftUI

struct ItemDetailView: View {
    let item: Item
    @StateObject private var viewModel: ItemDetailViewModel
    @State private var showingLend = false
    @State private var showingEdit = false
    @Environment(\.presentationMode) var presentationMode
    
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
                
                Text(NSLocalizedString(item.category.rawValue, comment: "Category name"))
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                if let platform = item.platform {
                    Text("\(NSLocalizedString("Platform", comment: "Label")): \(platform)")
                        .font(.body)
                }
                
                if let notes = item.notes {
                    Text("\(NSLocalizedString("Notes", comment: "Label")): \(notes)")
                        .font(.body)
                }
                
                Text("\(NSLocalizedString("Status", comment: "Label")): \(NSLocalizedString(viewModel.item.status.rawValue, comment: "Status"))")
                    .font(.headline)
                    .foregroundColor(viewModel.item.status == .available ? .green : .red)
                
                if viewModel.item.status == .available {
                    Button(NSLocalizedString("Lend Item", comment: "Button")) {
                        showingLend = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                    .accessibilityIdentifier("lendItemButton")
                } else {
                    if let currentLoan = viewModel.loans.first(where: { $0.returnDate == nil }) {
                        Button(NSLocalizedString("Mark as Returned", comment: "Button")) {
                            viewModel.returnItem(loan: currentLoan)
                        }
                        .buttonStyle(.bordered)
                        .padding(.top)
                    }
                }
                
                if !viewModel.loans.isEmpty {
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("Loan History", comment: "Section title"))
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
                                    Text(" - \(NSLocalizedString("Ongoing", comment: "Loan status"))")
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
        .navigationBarItems(trailing: Button("Edit") {
            showingEdit = true
        })
        .sheet(isPresented: $showingLend) {
            LoanFlowView(item: item, viewModel: viewModel)
        }
        .sheet(isPresented: $showingEdit) {
            AddItemView(item: item)
        }
        .onChange(of: viewModel.itemDeleted) { _, deleted in
            if deleted {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ItemDeleted"))) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
}