import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var viewModel: FriendsViewModel
    @State private var showingAddFriend = false
    @State private var friendToEdit: Friend? = nil
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.friends) { friend in
                    VStack(alignment: .leading) {
                        Text(friend.name)
                            .font(.headline)
                        if let email = friend.email {
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Edit") {
                            friendToEdit = friend
                        }
                        .tint(.blue)
                        
                        Button("Delete", role: .destructive) {
                            viewModel.removeFriend(friend)
                        }
                    }
                }
            }
            
            Button("Add Friend") {
                showingAddFriend = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Friends")
        .sheet(isPresented: $showingAddFriend) {
            AddFriendView()
        }
        .sheet(item: $friendToEdit) { friend in
            AddFriendView(friend: friend)
        }
    }
}