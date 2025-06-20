import Inject
import SwiftUI

struct ExtractionDigitalDisplayView: View {
    @ObserveInjection var inject
    let currentTime: Int
    let currentWeight: Int

    var body: some View {
        HStack(spacing: 40) {
            self.digitalCounter(
                title: "時間",
                value: self.formatTime(self.currentTime),
                color: Color.white
            )

            self.digitalCounter(
                title: "重量",
                value: "\(self.currentWeight)g",
                color: Color.white
            )
        }
        .padding(.vertical, 20)
        .enableInjection()
    }

    private func digitalCounter(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color("DarkBrown"))

            Text(value)
                .font(.system(size: 24, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(color)
                .frame(minWidth: 80)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color("DarkBrown"))
                .cornerRadius(8)
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
