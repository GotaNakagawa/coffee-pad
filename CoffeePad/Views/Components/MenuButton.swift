import SwiftUI

struct MenuButton: View {
    let title: String
    let imageName: String
    let backgroundColor: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(self.backgroundColor)
                    .frame(width: 64, height: 64)
                    .shadow(radius: 4)

                Image(self.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }

            Text(self.title)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}
