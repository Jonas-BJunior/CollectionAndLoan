import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var viewModel: CollectionViewModel
    @State private var showingAddItem = false
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                    ForEach(viewModel.filteredItems) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
                            ItemCardView(item: item)
                        }
                        .accessibilityIdentifier("item_\(item.id.uuidString)")
                    }
                }
                .padding()
            }
            
            Button(action: { showingAddItem = true }) {
                Text(NSLocalizedString("Add Item", comment: "Button to add new item"))
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            viewModel.loadItems()
        }
        .navigationTitle(NSLocalizedString("My Collections", comment: "Navigation title"))
        .toolbar {
            Menu {
                Button {
                    viewModel.selectedCategory = nil
                } label: {
                    HStack {
                        if viewModel.selectedCategory == nil {
                            Image(systemName: "checkmark")
                        }
                        Text(NSLocalizedString("All", comment: "Category filter"))
                    }
                }
                ForEach(Category.allCases) { category in
                    Button {
                        viewModel.selectedCategory = category
                    } label: {
                        HStack {
                            if viewModel.selectedCategory == category {
                                Image(systemName: "checkmark")
                            }
                            Text(NSLocalizedString(category.rawValue, comment: "Category name"))
                        }
                    }
                }
            } label: {
                Image(systemName: "line.horizontal.3.decrease.circle")
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView()
        }
    }
}