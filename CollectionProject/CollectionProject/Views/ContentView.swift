import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                CollectionView()
            }
            .tabItem {
                Label(NSLocalizedString("Collection", comment: "Tab bar item"), systemImage: "square.grid.2x2")
            }
            
            NavigationStack {
                FriendsView()
            }
            .tabItem {
                Label(NSLocalizedString("Friends", comment: "Tab bar item"), systemImage: "person.2")
            }
        }
    }
}