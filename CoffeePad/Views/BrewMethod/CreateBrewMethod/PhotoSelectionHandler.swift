import PhotosUI
import SwiftUI

/// 写真選択とクロップ処理を管理するヘルパークラス
@MainActor
class PhotoSelectionHandler: ObservableObject {
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedUIImage: UIImage?
    @Published var cropOffset = CGSize.zero
    @Published var lastOffset = CGSize.zero
    @Published var scale: CGFloat = 1.0
    @Published var lastScale: CGFloat = 1.0
    @Published var isCropping = false
    @Published var isEditingImage = false

    private let cropSize: CGFloat

    init(cropSize: CGFloat) {
        self.cropSize = cropSize
    }

    /// 画像選択開始時の状態設定
    func startImageSelection() {
        DispatchQueue.main.async {
            self.isEditingImage = true
        }
    }

    /// 画像選択処理
    func handleImageSelection(_ item: PhotosPickerItem?, existingImageData: Data?) async {
        guard let item else {
            return
        }

        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let originalImage = UIImage(data: data) {
                // 新しい画像が選択された場合
                await self.setupImageForCropping(originalImage)
            } else if let existingData = existingImageData,
                      let existingImage = UIImage(data: existingData) {
                // 同じ画像が選択された場合、既存画像を再編集
                await self.setupImageForCropping(existingImage)
            }
        } catch {
            print("画像の読み込みに失敗しました: \(error)")
            // エラー時は編集状態をリセット
            self.isEditingImage = false
        }
    }

    /// 画像をクロップ用にセットアップ
    private func setupImageForCropping(_ image: UIImage) async {
        let fixedImage = self.fixImageOrientation(image)
        self.selectedUIImage = fixedImage
        self.resetCropParameters()
        self.isCropping = true
    }

    /// クロップパラメータをリセット
    func resetCropParameters() {
        self.scale = 1.0
        self.lastScale = 1.0
        self.cropOffset = .zero
        self.lastOffset = .zero
    }

    /// ドラッグジェスチャーハンドリング
    func handleDragChanged(_ value: DragGesture.Value) {
        self.cropOffset = CGSize(
            width: self.lastOffset.width + value.translation.width,
            height: self.lastOffset.height + value.translation.height
        )
    }

    func handleDragEnded(_ value: DragGesture.Value) {
        self.lastOffset = self.cropOffset
    }

    /// 拡大縮小ジェスチャーハンドリング
    func handleMagnificationChanged(_ value: MagnificationGesture.Value) {
        self.scale = max(0.1, self.lastScale * value)
    }

    func handleMagnificationEnded(_ value: MagnificationGesture.Value) {
        self.lastScale = self.scale
    }

    /// 画像の向きを修正
    private func fixImageOrientation(_ image: UIImage) -> UIImage {
        guard image.imageOrientation != .up else {
            return image
        }

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage ?? image
    }

    /// クロップ範囲が画像内に収まっているかチェック
    func isCropAreaCompletelyWithinImage() -> Bool {
        guard let image = selectedUIImage else {
            return false
        }

        let containerSize = CGSize(width: 400, height: 350)
        let imageSize = image.size
        let scaleX = containerSize.width / imageSize.width
        let scaleY = containerSize.height / imageSize.height
        let aspectScale = min(scaleX, scaleY)

        let scaledImageSize = CGSize(
            width: imageSize.width * aspectScale * self.scale,
            height: imageSize.height * aspectScale * self.scale
        )

        let imageFrame = CGRect(
            x: (containerSize.width - scaledImageSize.width) / 2 + self.cropOffset.width,
            y: (containerSize.height - scaledImageSize.height) / 2 + self.cropOffset.height,
            width: scaledImageSize.width,
            height: scaledImageSize.height
        )

        let cropFrame = CGRect(
            x: (containerSize.width - self.cropSize) / 2,
            y: (containerSize.height - self.cropSize) / 2,
            width: self.cropSize,
            height: self.cropSize
        )

        return imageFrame.contains(cropFrame)
    }

    /// 画像をクロップして保存
    func cropAndSaveImage() -> Data? {
        guard let image = selectedUIImage else {
            return nil
        }

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: cropSize, height: cropSize))

        let croppedImage = renderer.image { _ in
            let imageSize = image.size
            let containerSize = CGSize(width: 400, height: 350)

            let scaleX = containerSize.width / imageSize.width
            let scaleY = containerSize.height / imageSize.height
            let aspectScale = min(scaleX, scaleY)

            let scaledImageSize = CGSize(
                width: imageSize.width * aspectScale * self.scale,
                height: imageSize.height * aspectScale * self.scale
            )

            let imageOrigin = CGPoint(
                x: (containerSize.width - scaledImageSize.width) / 2 + self.cropOffset.width,
                y: (containerSize.height - scaledImageSize.height) / 2 + self.cropOffset.height
            )

            let cropRect = CGRect(
                x: (containerSize.width - self.cropSize) / 2 - imageOrigin.x,
                y: (containerSize.height - self.cropSize) / 2 - imageOrigin.y,
                width: self.cropSize,
                height: self.cropSize
            )

            let normalizedCropRect = CGRect(
                x: cropRect.minX / scaledImageSize.width,
                y: cropRect.minY / scaledImageSize.height,
                width: cropRect.width / scaledImageSize.width,
                height: cropRect.height / scaledImageSize.height
            )

            let sourceCropRect = CGRect(
                x: normalizedCropRect.minX * imageSize.width,
                y: normalizedCropRect.minY * imageSize.height,
                width: normalizedCropRect.width * imageSize.width,
                height: normalizedCropRect.height * imageSize.height
            )

            if let cgImage = image.cgImage?.cropping(to: sourceCropRect) {
                let croppedUIImage = UIImage(cgImage: cgImage)
                croppedUIImage.draw(in: CGRect(
                    origin: .zero,
                    size: CGSize(width: self.cropSize, height: self.cropSize)
                ))
            }
        }

        return croppedImage.jpegData(compressionQuality: 0.8)
    }

    /// クロップ完了処理
    func completeCropping() -> Data? {
        let imageData = self.cropAndSaveImage()
        self.selectedUIImage = nil
        self.isCropping = false
        DispatchQueue.main.async {
            self.isEditingImage = false
        }
        return imageData
    }
}
