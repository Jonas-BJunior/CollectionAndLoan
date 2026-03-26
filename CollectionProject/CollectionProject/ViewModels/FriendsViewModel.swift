import Foundation
import Combine

class FriendsViewModel: ObservableObject {
    @Published var friends: [Friend] = []
    
    private let friendRepository: FriendRepository
    
    init() {
        self.friendRepository = AppDependencies.friendRepository
        loadFriends()
    }
    
    func loadFriends() {
        friends = friendRepository.getAll()
    }
    
    func addFriend(_ friend: Friend) {
        friendRepository.add(friend)
        loadFriends()
    }
}