import UIKit

enum YouTubeThumbnailHandler {
    static func downloadThumbnailImage(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            DispatchQueue.main.async {
                // 画像をアスペクト比を保ったままリサイズ（上下に白い余白を追加）
                if let image = UIImage(data: data) {
                    let imageData = self.createSquareImageWithPadding(from: image)
                    completion(imageData)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }

    private static func createSquareImageWithPadding(from image: UIImage) -> Data? {
        let targetSize = CGSize(width: 300, height: 300)
        let imageAspectRatio = image.size.width / image.size.height

        let scaledSize = if imageAspectRatio > 1 {
            // 横長の画像
            CGSize(width: targetSize.width, height: targetSize.width / imageAspectRatio)
        } else {
            // 縦長または正方形の画像
            CGSize(width: targetSize.height * imageAspectRatio, height: targetSize.height)
        }

        let yOffset = (targetSize.height - scaledSize.height) / 2
        let xOffset = (targetSize.width - scaledSize.width) / 2

        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)

        // 白い背景を描画
        UIColor.white.setFill()
        UIRectFill(CGRect(origin: .zero, size: targetSize))

        // 画像を中央に描画
        image.draw(in: CGRect(x: xOffset, y: yOffset, width: scaledSize.width, height: scaledSize.height))

        let paddedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return paddedImage?.jpegData(compressionQuality: 0.8)
    }
}
