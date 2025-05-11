import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            CreateView()
                .tabItem {
                    Label("つくる", systemImage: "cup.and.saucer")
                }

            ViewItemsView()
                .tabItem {
                    Label("みる", systemImage: "list.bullet")
                }
        }
    }
}
