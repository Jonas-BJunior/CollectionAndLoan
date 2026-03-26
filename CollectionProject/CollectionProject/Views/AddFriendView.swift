import SwiftUI

struct AddFriendView: View {
    @EnvironmentObject var viewModel: FriendsViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var email = ""
    private let friend: Friend?
    private let isEditing: Bool
    
    init(friend: Friend? = nil) {
        self.friend = friend
        self.isEditing = friend != nil
        if let friend = friend {
            _name = State(initialValue: friend.name)
            _email = State(initialValue: friend.email ?? "")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField(NSLocalizedString("Name", comment: "Field label"), text: $name)
                TextField(NSLocalizedString("Email", comment: "Field label"), text: $email)
            }
            .navigationTitle(isEditing ? NSLocalizedString("Edit Friend", comment: "Navigation title") : NSLocalizedString("Add Friend", comment: "Navigation title"))
            .navigationBarItems(trailing: Button(NSLocalizedString("Save", comment: "Button")) {
                if isEditing, let friend = friend {
                    var updatedFriend = friend
                    updatedFriend.name = name
                    updatedFriend.email = email.isEmpty ? nil : email
                    viewModel.updateFriend(updatedFriend)
                } else {
                    let newFriend = Friend(name: name, email: email.isEmpty ? nil : email)
                    viewModel.addFriend(newFriend)
                }
                dismiss()
            })
        }
    }
}