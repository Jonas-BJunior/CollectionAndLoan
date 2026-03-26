import SwiftUI

struct AddItemView: View {
    @EnvironmentObject var viewModel: CollectionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var category: Category = .game
    @State private var platform = ""
    @State private var notes = ""
    private let item: Item?
    private let isEditing: Bool
    
    init(item: Item? = nil) {
        self.item = item
        self.isEditing = item != nil
        if let item = item {
            _title = State(initialValue: item.title)
            _category = State(initialValue: item.category)
            _platform = State(initialValue: item.platform ?? "")
            _notes = State(initialValue: item.notes ?? "")
        }
    }
    
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
            .navigationTitle(isEditing ? "Edit Item" : "Add Item")
            .navigationBarItems(trailing: Button("Save") {
                if isEditing, let item = item {
                    var updatedItem = item
                    updatedItem.title = title
                    updatedItem.category = category
                    updatedItem.platform = platform.isEmpty ? nil : platform
                    updatedItem.notes = notes.isEmpty ? nil : notes
                    viewModel.updateItem(updatedItem)
                } else {
                    let newItem = Item(title: title, category: category, platform: platform.isEmpty ? nil : platform, notes: notes.isEmpty ? nil : notes)
                    viewModel.addItem(newItem)
                }
                dismiss()
            })
        }
    }
}