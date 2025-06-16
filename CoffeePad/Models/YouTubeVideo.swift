import Foundation

struct YouTubeVideo {
    let id: String
    let title: String
    let description: String
    let thumbnailURL: String
    let duration: String
    let publishedAt: String
}

enum YouTubeAPIService {
    static func fetchVideoInfo(from urlString: String, completion: @escaping (Result<YouTubeVideo, Error>) -> Void) {
        // YouTube APIからビデオ情報を取得
        // 現在はモック実装
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            DispatchQueue.main.async {
                // モックデータ
                let mockVideo = YouTubeVideo(
                    id: "dQw4w9WgXcQ",
                    title: "完璧なV60ドリップコーヒーの淹れ方",
                    description: "プロのバリスタが教える、V60を使った美味しいコーヒーの淹れ方を詳しく解説します。豆の選び方から抽出まで、すべてのステップを丁寧に説明します。",
                    thumbnailURL: "https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg",
                    duration: "8:45",
                    publishedAt: "2024-01-15"
                )

                completion(.success(mockVideo))
            }
        }
    }
}
