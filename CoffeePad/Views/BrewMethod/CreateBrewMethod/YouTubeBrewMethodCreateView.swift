import Inject
import SwiftUI

struct YouTubeBrewMethodCreateView: View {
    @ObserveInjection var inject
    @Environment(\.dismiss) private var dismiss

    @State private var youtubeURL = ""
    @State private var videoInfo: YouTubeVideo?
    @State private var isLoading = false
    @State private var errorMessage: String?

    // BrewMethod作成用の状態
    @State private var title = ""
    @State private var comment = ""
    @State private var amount = ""
    @State private var grind = ""
    @State private var temp = ""
    @State private var weight = ""
    @State private var steps: [BrewStep] = []
    @State private var thumbnailImageData: Data?

    var body: some View {
        VStack(spacing: 0) {
            self.navigationHeader

            ScrollView {
                VStack(spacing: 24) {
                    YouTubeInputSectionView(
                        youtubeURL: self.$youtubeURL,
                        isLoading: self.$isLoading,
                        errorMessage: self.$errorMessage,
                        onCreateMethod: self.createBrewMethodFromVideo
                    )

                    if let video = self.videoInfo {
                        self.videoPreviewSection(video: video)
                        YouTubeMethodContentView(
                            title: self.title,
                            comment: self.comment,
                            amount: self.amount,
                            weight: self.weight,
                            grind: self.grind,
                            temp: self.temp,
                            steps: self.steps,
                            onCreateMethod: self.createBrewMethod
                        )
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .enableInjection()
    }

    private var navigationHeader: some View {
        HStack {
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 20)
                .padding(.leading, 20)
                .onTapGesture {
                    self.dismiss()
                }
            Spacer()
            Text("YouTube動画から作成")
                .font(.headline)
            Spacer()
            Color.clear.frame(width: 32, height: 20)
        }
        .padding(.top, 24)
        .padding(.bottom, 8)
    }

    private func videoPreviewSection(video: YouTubeVideo) -> some View {
        YouTubeVideoPreviewView(video: video)
            .padding(.horizontal, 20)
    }

    private func createBrewMethod() {
        let data = BrewMethodData(
            title: self.title,
            comment: self.comment,
            amount: self.amount,
            weight: self.weight,
            grind: self.grind,
            temp: self.temp,
            steps: self.steps,
            thumbnailImageData: self.thumbnailImageData
        )
        YouTubeBrewMethodCreator.createBrewMethod(from: data)
        self.dismiss()
    }

    private func createBrewMethodFromVideo() {
        self.isLoading = true
        self.errorMessage = nil

        YouTubeAPIService.fetchVideoInfo(from: self.youtubeURL) { result in
            self.isLoading = false

            switch result {
            case let .success(video):
                self.videoInfo = video
                self.populateFields(from: video)
            case let .failure(error):
                self.errorMessage = "動画情報の取得に失敗しました: \(error.localizedDescription)"
            }
        }
    }

    private func populateFields(from video: YouTubeVideo) {
        self.title = video.title
        self.comment = "YouTube動画「\(video.title)」から作成"
        self.amount = "20"
        self.weight = "300"
        self.grind = "中細挽き"
        self.temp = "92"

        // YouTubeサムネイル画像をダウンロード
        YouTubeThumbnailHandler.downloadThumbnailImage(from: video.thumbnailURL) { imageData in
            self.thumbnailImageData = imageData
        }

        // デフォルトのドリップステップを作成
        self.steps = YouTubeBrewMethodCreator.createDefaultSteps()
    }
}
