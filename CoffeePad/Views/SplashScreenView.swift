import AVKit
import Inject
import SwiftUI

struct SplashScreenView: View {
    @ObserveInjection var inject
    @State private var isActive = false
    @State private var player: AVPlayer?
    @State private var videoSize: CGSize = .zero

    private let backgroundColor = Color("SplashVideoBrown")

    var body: some View {
        Group {
            if self.isActive {
                ContentView()
            } else {
                GeometryReader { geometry in
                    ZStack {
                        self.backgroundColor
                            .ignoresSafeArea()

                        if let player {
                            CustomVideoPlayer(player: player, videoSize: self.$videoSize)
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(maxWidth: min(geometry.size.width, geometry.size.height))
                                .clipped()
                        }
                    }
                }
                .onAppear {
                    self.playVideo()
                }
            }
        }
        .enableInjection()
    }

    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "splash_video", ofType: "mov") else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.isActive = true
                }
            }
            return
        }

        let url = URL(fileURLWithPath: path)
        let asset = AVAsset(url: url)
        self.player = AVPlayer(url: url)

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: self.player?.currentItem,
            queue: .main
        ) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isActive = true
            }
        }

        self.player?.play()

        Task {
            do {
                let duration = try await asset.load(.duration)
                let durationInSeconds = CMTimeGetSeconds(duration)

                DispatchQueue.main.asyncAfter(deadline: .now() + durationInSeconds + 0.5) {
                    if !self.isActive {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.isActive = true
                        }
                    }
                }
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    if !self.isActive {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

private struct CustomVideoPlayer: UIViewRepresentable {
    let player: AVPlayer
    @Binding var videoSize: CGSize

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        view.layer.addSublayer(playerLayer)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let playerLayer = uiView.layer.sublayers?.first as? AVPlayerLayer else {
            return
        }

        DispatchQueue.main.async {
            playerLayer.frame = uiView.bounds
        }
    }
}
