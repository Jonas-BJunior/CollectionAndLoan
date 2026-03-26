import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                CollectionView()
            }
            .tabItem {
                Label("Collection", systemImage: "square.grid.2x2")
            }
            
            NavigationStack {
                FriendsView()
            }
            .tabItem {
                Label("Friends", systemImage: "person.2")
            }
        }
    }
}