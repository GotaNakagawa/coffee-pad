import AVKit
import Inject
import SwiftUI

struct ColorComparisonView: View {
    @ObserveInjection var inject
    @State private var player: AVPlayer?

    var body: some View {
        VStack(spacing: 20) {
            headerView
            colorComparisonView
            currentSettingsView
            controlButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("SplashVideoBrown"))
        .onAppear {
            self.setupPlayer()
        }
        .enableInjection()
    }
    
    private var headerView: some View {
        Text("色比較デバッグ")
            .font(.title)
    }
    
    private var colorComparisonView: some View {
        HStack(spacing: 20) {
            colorSampleView
            videoView
        }
    }
    
    private var colorSampleView: some View {
        VStack {
            Color("SplashVideoBrown")
                .frame(width: 150, height: 150)
                .border(Color.white, width: 2)
            Text("SplashVideoBrown")
                .foregroundColor(.white)
        }
    }
    
    private var videoView: some View {
        VStack {
            if let player {
                VideoPlayer(player: player)
                    .frame(width: 150, height: 150)
                    .border(Color.white, width: 2)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 150, height: 150)
            }
            Text("動画背景")
                .foregroundColor(.white)
        }
    }
    
    private var currentSettingsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("現在の設定:")
                .foregroundColor(.white)
                .font(.headline)
            
            Text("RGB: (66, 41, 40)")
                .foregroundColor(.white)
            Text("Hex: #422928")
                .foregroundColor(.white)
            Text("正規化: (0.259, 0.161, 0.157)")
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
    }
    
    private var controlButton: some View {
        Button("動画を停止/再生") {
            toggleVideo()
        }
        .padding()
        .background(Color.white)
        .foregroundColor(.black)
        .cornerRadius(10)
    }
    
    private func toggleVideo() {
        if let player {
            if player.rate > 0 {
                player.pause()
            } else {
                player.play()
            }
        }
    }

    private func setupPlayer() {
        guard let path = Bundle.main.path(forResource: "splash_video", ofType: "mov") else {
            return
        }

        let url = URL(fileURLWithPath: path)
        self.player = AVPlayer(url: url)
        self.player?.play()
    }
}

#Preview {
    ColorComparisonView()
}
