import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var viewModel: CollectionViewModel
    @State private var showingAddItem = false
    
    var body: some View {
        VStack {
            Picker("Category", selection: $viewModel.selectedCategory) {
                Text("All").tag(Category?.none)
                ForEach(Category.allCases) { category in
                    Text(category.rawValue.capitalized).tag(category as Category?)
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
                Text("Add Item")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("My Collection")
        .sheet(isPresented: $showingAddItem) {
            AddItemView()
        }
    }
}