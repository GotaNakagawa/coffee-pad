import SwiftUI

struct CreateView: View {
    var body: some View {
        VStack {
            Text("ここでアイテムをつくる画面です")
            // 将来的にフォームや画像追加などに発展させられます
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
