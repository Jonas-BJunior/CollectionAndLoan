import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var viewModel: CollectionViewModel
    @State private var showingAddItem = false
    
    var body: some View {
        VStack {
            Picker("", selection: $viewModel.selectedCategory) {
                Text(NSLocalizedString("All", comment: "Category filter")).tag(Category?.none)
                ForEach(Category.allCases) { category in
                    Text(NSLocalizedString(category.rawValue, comment: "Category name")).tag(category as Category?)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                    ForEach(viewModel.filteredItems) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
                            ItemCardView(item: item)
                        }
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
        .sheet(isPresented: $showingAddItem) {
            AddItemView()
        }
    }
}