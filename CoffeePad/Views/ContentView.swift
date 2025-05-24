import Inject
import SwiftUI

struct ContentView: View {
    @ObserveInjection var inject

    var body: some View {
        HomeView()
            .enableInjection()
    }
}
