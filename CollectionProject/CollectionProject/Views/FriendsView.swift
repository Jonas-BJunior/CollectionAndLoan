import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var viewModel: FriendsViewModel
    @State private var showingAddFriend = false
    
    var body: some View {
        VStack {
            List(viewModel.friends) { friend in
                VStack(alignment: .leading) {
                    Text(friend.name)
                        .font(.headline)
                    if let email = friend.email {
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
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
    }
}