import Inject
import SwiftUI

struct YouTubeInputSectionView: View {
    @ObserveInjection var inject
    @Binding var youtubeURL: String
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?
    let onCreateMethod: () -> Void

    private var isValidURL: Bool {
        !self.youtubeURL.isEmpty &&
            (self.youtubeURL.contains("youtube.com") || self.youtubeURL.contains("youtu.be"))
    }

    var body: some View {
        VStack(spacing: 16) {
            self.urlInputField
            self.createMethodButton
            self.errorMessageView
        }
        .padding(.horizontal, 20)
        .enableInjection()
    }

    private var urlInputField: some View {
        CreateBrewMethodStepTextField(
            title: "YouTube URL",
            description: "YouTube動画のURLを入力してください",
            text: self.$youtubeURL,
            placeholder: "https://www.youtube.com/watch?v=...",
            keyboardType: .URL
        )
    }

    private var createMethodButton: some View {
        Button(
            action: self.onCreateMethod,
            label: {
                HStack {
                    Spacer()
                    if self.isLoading {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("読み込み中...")
                        }
                    } else {
                        Text("動画からメソッドを作成")
                    }
                    Spacer()
                }
                .font(.body)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(self.isValidURL && !self.isLoading ? Color("DeepGreen") : Color.gray)
                .cornerRadius(8)
            }
        )
        .buttonStyle(.plain)
        .disabled(!self.isValidURL || self.isLoading)
    }

    @ViewBuilder
    private var errorMessageView: some View {
        if let error = errorMessage {
            Text(error)
                .font(.caption)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
        }
    }
}
