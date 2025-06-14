import SwiftUI

struct BrewMethodIconView: View {
    let iconData: Data?
    let size: CGFloat
    let radius: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: self.radius)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.cyan.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .aspectRatio(1, contentMode: .fit)
                .frame(width: self.size, height: self.size)
                .overlay(
                    Group {
                        if let iconData, let uiImage = UIImage(data: iconData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: self.size, height: self.size)
                                .clipped()
                                .cornerRadius(self.radius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: self.radius)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        } else {
                            Text("No Image")
                                .font(.system(size: self.size * 0.2, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                )
        }
    }
}
