import SwiftUI

struct AddItemView: View {
    @EnvironmentObject var viewModel: CollectionViewModel
    @Environment(\.dismiss) var dismiss

    @StateObject private var formViewModel: ItemFormViewModel
    private let item: Item?
    private let isEditing: Bool
    @State private var showingDeleteAlert = false

    init(item: Item? = nil) {
        self.item = item
        self.isEditing = item != nil
        _formViewModel = StateObject(wrappedValue: ItemFormViewModel(item: item))
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(NSLocalizedString("Title", comment: "Field label"), text: $formViewModel.title)

                    if formViewModel.shouldShowValidation, let titleErrorMessage = formViewModel.titleErrorMessage {
                        Text(titleErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                Picker(NSLocalizedString("Category", comment: "Field label"), selection: $formViewModel.category) {
                    ForEach(Category.allCases) { cat in
                        Text(NSLocalizedString(cat.rawValue, comment: "Category name")).tag(cat)
                    }
                }
                TextField(NSLocalizedString("Platform", comment: "Field label"), text: $formViewModel.platform)
                TextField(NSLocalizedString("Notes", comment: "Field label"), text: $formViewModel.notes)
                
                if isEditing {
                    Section {
                        Button(NSLocalizedString("Delete Item", comment: "Button")) {
                            showingDeleteAlert = true
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle(isEditing ? NSLocalizedString("Edit Item", comment: "Navigation title") : NSLocalizedString("Add Item", comment: "Navigation title"))
            .navigationBarItems(trailing: Button(NSLocalizedString("Save", comment: "Button")) {
                formViewModel.didAttemptSave = true
                guard formViewModel.isFormValid else { return }

                if isEditing, let item = item {
                    var updatedItem = item
                    updatedItem.title = formViewModel.normalizedTitle
                    updatedItem.category = formViewModel.category
                    updatedItem.platform = formViewModel.normalizedPlatform
                    updatedItem.notes = formViewModel.normalizedNotes
                    viewModel.updateItem(updatedItem)
                } else {
                    let newItem = Item(
                        title: formViewModel.normalizedTitle,
                        category: formViewModel.category,
                        platform: formViewModel.normalizedPlatform,
                        notes: formViewModel.normalizedNotes
                    )
                    viewModel.addItem(newItem)
                }
                dismiss()
            }
            .disabled(!formViewModel.isFormValid))
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text(NSLocalizedString("Delete Item", comment: "Alert title")),
                    message: Text(NSLocalizedString("Are you sure you want to delete this item? This action cannot be undone.", comment: "Alert message")),
                    primaryButton: .destructive(Text(NSLocalizedString("Delete", comment: "Button"))) {
                        if let item = item {
                            viewModel.deleteItem(item)
                            NotificationCenter.default.post(name: NSNotification.Name("ItemDeleted"), object: nil)
                        }
                        dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}