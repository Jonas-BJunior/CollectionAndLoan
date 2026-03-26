import SwiftUI

struct AddFriendView: View {
    @EnvironmentObject var viewModel: FriendsViewModel
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var formViewModel: FriendFormViewModel
    private let friend: Friend?
    private let isEditing: Bool
    
    init(friend: Friend? = nil) {
        self.friend = friend
        self.isEditing = friend != nil
        _formViewModel = StateObject(wrappedValue: FriendFormViewModel(friend: friend))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(NSLocalizedString("Name", comment: "Field label"), text: $formViewModel.name)
                        .autocapitalization(.words)

                    if shouldShowValidation, let nameErrorMessage {
                        Text(nameErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                Section {
                    TextField(NSLocalizedString("Email", comment: "Field label"), text: $formViewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    if shouldShowValidation, let emailErrorMessage {
                        Text(emailErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle(isEditing ? NSLocalizedString("Edit Friend", comment: "Navigation title") : NSLocalizedString("Add Friend", comment: "Navigation title"))
            .navigationBarItems(trailing: Button(NSLocalizedString("Save", comment: "Button")) {
                formViewModel.didAttemptSave = true
                guard isFormValid else { return }

                if isEditing, let friend = friend {
                    var updatedFriend = friend
                    updatedFriend.name = formViewModel.normalizedName
                    updatedFriend.email = formViewModel.normalizedEmail
                    viewModel.updateFriend(updatedFriend)
                } else {
                    let newFriend = Friend(name: formViewModel.normalizedName, email: formViewModel.normalizedEmail)
                    viewModel.addFriend(newFriend)
                }
                dismiss()
            }
            .disabled(!isFormValid))
        }
    }

    private var shouldShowValidation: Bool {
        formViewModel.shouldShowValidation
    }

    private var isFormValid: Bool {
        formViewModel.isFormValid
    }

    private var nameErrorMessage: String? {
        formViewModel.nameErrorMessage
    }

    private var emailErrorMessage: String? {
        formViewModel.emailErrorMessage
    }
}