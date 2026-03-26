import Foundation
import Combine

@MainActor
final class FriendFormViewModel: FormStateValidating {
    @Published var name: String
    @Published var email: String
    @Published var didAttemptSave = false

    init(friend: Friend? = nil) {
        self.name = friend?.name ?? ""
        self.email = friend?.email ?? ""
    }

    var hasAnyUserInput: Bool {
        !name.isEmpty || !email.isEmpty
    }

    var nameErrorMessage: String? {
        FriendFormValidator.validateName(name)
    }

    var emailErrorMessage: String? {
        FriendFormValidator.validateEmail(email)
    }

    var isFormValid: Bool {
        nameErrorMessage == nil && emailErrorMessage == nil
    }

    var normalizedName: String {
        FormValueNormalizer.trimmed(name)
    }

    var normalizedEmail: String? {
        FormValueNormalizer.nilIfEmpty(email)
    }
}

@MainActor
class FriendsViewModel: ObservableObject {
    @Published var friends: [Friend] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let friendService: FriendServiceProtocol

    init(friendService: FriendServiceProtocol) {
        self.friendService = friendService
        loadFriends()
    }

    convenience init() {
        self.init(friendService: AppDependencies.friendService)
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
