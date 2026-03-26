import SwiftUI

@main
struct CollectionProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CollectionViewModel())
                .environmentObject(FriendsViewModel())
        }
    }
}