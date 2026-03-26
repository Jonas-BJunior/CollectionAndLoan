import SwiftUI

struct AddFriendView: View {
    @EnvironmentObject var viewModel: FriendsViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
            }
            .navigationTitle("Add Friend")
            .navigationBarItems(trailing: Button("Save") {
                let friend = Friend(name: name, email: email.isEmpty ? nil : email)
                viewModel.addFriend(friend)
                dismiss()
            })
        }
    }
}