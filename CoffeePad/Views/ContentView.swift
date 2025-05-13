import SwiftUI
import SwiftData
import Inject

struct ContentView: View {
    @ObserveInjection var inject
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
        .enableInjection()
    }
}
