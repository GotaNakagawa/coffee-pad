import SwiftUI

struct ExtractionStats: View {
    var body: some View {
        HStack(spacing: 16) {
            VStack {
                Text("2件").bold()
                Text("今月の作成数").font(.caption).foregroundColor(.gray)
            }

            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 1, height: 30)
                .cornerRadius(0.5)

            VStack {
                Text("3件").bold()
                Text("総作成数").font(.caption).foregroundColor(.gray)
            }
        }
    }
}
