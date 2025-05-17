import SwiftUI
import Inject

struct ContentView: View {
    @ObserveInjection var inject

    var body: some View {
        HomeView()
            .enableInjection()
    }
}
