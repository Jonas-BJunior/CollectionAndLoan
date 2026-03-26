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
                TextField(NSLocalizedString("Title", comment: "Field label"), text: $title)
                Picker(NSLocalizedString("Category", comment: "Field label"), selection: $category) {
                    ForEach(Category.allCases) { cat in
                        Text(NSLocalizedString(cat.rawValue, comment: "Category name")).tag(cat)
                    }
                }
                TextField(NSLocalizedString("Platform", comment: "Field label"), text: $platform)
                TextField(NSLocalizedString("Notes", comment: "Field label"), text: $notes)
            }
            .navigationTitle(isEditing ? NSLocalizedString("Edit Item", comment: "Navigation title") : NSLocalizedString("Add Item", comment: "Navigation title"))
            .navigationBarItems(trailing: Button(NSLocalizedString("Save", comment: "Button")) {
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