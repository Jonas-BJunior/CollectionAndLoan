import SwiftUI

struct AddItemView: View {
    @EnvironmentObject var viewModel: CollectionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var category: Category = .game
    @State private var platform = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                Picker("Category", selection: $category) {
                    ForEach(Category.allCases) { cat in
                        Text(cat.rawValue.capitalized).tag(cat)
                    }
                }
                TextField("Platform", text: $platform)
                TextField("Notes", text: $notes)
            }
            .navigationTitle("Add Item")
            .navigationBarItems(trailing: Button("Save") {
                let item = Item(title: title, category: category, platform: platform.isEmpty ? nil : platform, notes: notes.isEmpty ? nil : notes)
                viewModel.addItem(item)
                dismiss()
            })
        }
    }
}