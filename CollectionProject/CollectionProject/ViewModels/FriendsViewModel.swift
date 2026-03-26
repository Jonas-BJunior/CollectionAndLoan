import Foundation
import Combine

@MainActor
class FriendsViewModel: ObservableObject {
    @Published var friends: [Friend] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let friendService: FriendServiceProtocol

    init(friendService: FriendServiceProtocol = AppDependencies.friendService) {
        self.friendService = friendService
        loadFriends()
    }

    func loadFriends() {
        isLoading = true
        Task {
            do {
                friends = try await friendService.getAll()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func addFriend(_ friend: Friend) {
        Task {
            do {
                try await friendService.add(friend)
                friends = try await friendService.getAll()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func updateFriend(_ friend: Friend) {
        Task {
            do {
                try await friendService.update(friend)
                friends = try await friendService.getAll()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func removeFriend(_ friend: Friend) {
        Task {
            do {
                try await friendService.remove(friend)
                friends = try await friendService.getAll()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
