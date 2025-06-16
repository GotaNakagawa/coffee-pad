import Inject
import SwiftUI

struct YouTubeVideoPreviewView: View {
    @ObserveInjection var inject
    let video: YouTubeVideo

    var body: some View {
        VStack(spacing: 16) {
            Text("動画情報")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                AsyncImage(url: URL(string: self.video.thumbnailURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 180)
                }
                .frame(height: 180)
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 8) {
                    Text(self.video.title)
                        .font(.body)
                        .bold()
                        .multilineTextAlignment(.leading)

                    Text("再生時間: \(self.video.duration)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    if !self.video.description.isEmpty {
                        Text(self.video.description.prefix(100) + (self.video.description.count > 100 ? "..." : ""))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .enableInjection()
    }
}
