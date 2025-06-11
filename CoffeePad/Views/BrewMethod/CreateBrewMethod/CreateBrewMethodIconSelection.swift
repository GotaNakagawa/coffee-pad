import Inject
import PhotosUI
import SwiftUI

struct CreateBrewMethodIconSelection: View {
    @ObserveInjection var inject
    let title: String
    let description: String
    @Binding var selectedIconData: Data?

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedUIImage: UIImage?
    @State private var cropOffset = CGSize.zero
    @State private var lastOffset = CGSize.zero
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    private let cropSize: CGFloat = 280

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            self.headerSection

            if let selectedImage = self.selectedUIImage {
                ScrollView {
                    VStack(spacing: 20) {
                        self.imageCropSection(image: selectedImage)
                        self.cropActionButtons
                    }
                    .padding(.bottom, 20)
                }
            } else {
                self.imagePreviewSection
                self.photoPickerButton
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .enableInjection()
        .onChange(of: self.selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let originalImage = UIImage(data: data) {
                    await MainActor.run {
                        self.selectedUIImage = self.fixImageOrientation(originalImage)
                        self.cropOffset = .zero
                        self.lastOffset = .zero
                        self.scale = 1.0
                        self.lastScale = 1.0
                    }
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text(self.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }

    private var imagePreviewSection: some View {
        ImagePreviewView(selectedIconData: self.selectedIconData)
    }

    private var photoPickerButton: some View {
        PhotoPickerButtonView(
            selectedItem: self.$selectedItem,
            selectedIconData: self.selectedIconData
        )
    }

    private func imageCropSection(image: UIImage) -> some View {
        ImageCropSectionView(
            image: image,
            scale: self.scale,
            cropOffset: self.cropOffset,
            cropSize: self.cropSize,
            onDragChanged: { value in
                self.cropOffset = CGSize(
                    width: self.lastOffset.width + value.translation.width,
                    height: self.lastOffset.height + value.translation.height
                )
            },
            onDragEnded: { _ in
                self.lastOffset = self.cropOffset
            },
            onMagnificationChanged: { value in
                let newScale = self.lastScale * value
                let maxScale = self.calculateMaxScale(for: image, containerSize: CGSize(width: 400, height: 350))
                self.scale = max(0.5, min(newScale, maxScale))
            },
            onMagnificationEnded: { _ in
                self.lastScale = self.scale
            }
        )
    }

    private func calculateMaxScale(for image: UIImage, containerSize: CGSize) -> CGFloat {
        let imageSize = image.size
        let scaleX = containerSize.width / imageSize.width
        let scaleY = containerSize.height / imageSize.height
        let aspectScale = min(scaleX, scaleY)

        let maxScaleX = containerSize.width / (imageSize.width * aspectScale)
        let maxScaleY = containerSize.height / (imageSize.height * aspectScale)

        return max(maxScaleX, maxScaleY) * 1.2
    }

    private var cropActionButtons: some View {
        CropActionButtonsView(
            onBack: {
                self.selectedUIImage = nil
                self.selectedItem = nil
            },
            onComplete: {
                self.cropAndSaveImage()
            }
        )
    }

    private func cropAndSaveImage() {
        guard let image = self.selectedUIImage else {
            return
        }

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: self.cropSize, height: self.cropSize))

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

        self.selectedIconData = croppedImage.jpegData(compressionQuality: 0.8)
        self.selectedUIImage = nil
    }

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
}

private struct ImageCropSectionView: View {
    @ObserveInjection var inject
    let image: UIImage
    let scale: CGFloat
    let cropOffset: CGSize
    let cropSize: CGFloat
    let onDragChanged: (DragGesture.Value) -> Void
    let onDragEnded: (DragGesture.Value) -> Void
    let onMagnificationChanged: (MagnificationGesture.Value) -> Void
    let onMagnificationEnded: (MagnificationGesture.Value) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("切り取り範囲を調整してください")
                .font(.body)
                .foregroundColor(.secondary)

            ImageCropView(
                image: self.image,
                scale: self.scale,
                cropOffset: self.cropOffset,
                cropSize: self.cropSize,
                onDragChanged: self.onDragChanged,
                onDragEnded: self.onDragEnded,
                onMagnificationChanged: self.onMagnificationChanged,
                onMagnificationEnded: self.onMagnificationEnded
            )
        }
        .enableInjection()
    }
}

private struct ImagePreviewView: View {
    @ObserveInjection var inject
    let selectedIconData: Data?

    var body: some View {
        HStack {
            Spacer()
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 200, height: 200)
                .overlay(
                    Group {
                        if let iconData = self.selectedIconData,
                           let uiImage = UIImage(data: iconData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 200)
                                .clipped()
                                .cornerRadius(12)
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondary)
                                Text("写真を選択してください")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                )
            Spacer()
        }
        .enableInjection()
    }
}

private struct PhotoPickerButtonView: View {
    @ObserveInjection var inject
    @Binding var selectedItem: PhotosPickerItem?
    let selectedIconData: Data?

    var body: some View {
        PhotosPicker(
            selection: self.$selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            HStack {
                Image(systemName: "photo.on.rectangle")
                    .font(.title3)
                Text(self.selectedIconData == nil ? "写真を選択してクロップ" : "写真を変更")
                    .font(.body)
                    .bold()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color("DeepGreen"))
            .cornerRadius(8)
        }
        .enableInjection()
    }
}

private struct CropActionButtonsView: View {
    @ObserveInjection var inject
    let onBack: () -> Void
    let onComplete: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button("画像を変更") {
                self.onBack()
            }
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(8)

            Button("完了") {
                self.onComplete()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color("DeepGreen"))
            .cornerRadius(8)
        }
        .enableInjection()
    }
}

private struct ImageCropView: View {
    @ObserveInjection var inject
    let image: UIImage
    let scale: CGFloat
    let cropOffset: CGSize
    let cropSize: CGFloat
    let onDragChanged: (DragGesture.Value) -> Void
    let onDragEnded: (DragGesture.Value) -> Void
    let onMagnificationChanged: (MagnificationGesture.Value) -> Void
    let onMagnificationEnded: (MagnificationGesture.Value) -> Void

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image(uiImage: self.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(self.scale)
                    .offset(self.cropOffset)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .gesture(
                        SimultaneousGesture(
                            DragGesture()
                                .onChanged(self.onDragChanged)
                                .onEnded(self.onDragEnded),
                            MagnificationGesture()
                                .onChanged(self.onMagnificationChanged)
                                .onEnded(self.onMagnificationEnded)
                        )
                    )
            }
            .frame(height: 350)
            .clipped()

            CropOverlayView(cropSize: self.cropSize)
        }
        .enableInjection()
    }
}

private struct CropOverlayView: View {
    @ObserveInjection var inject
    let cropSize: CGFloat

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Rectangle()
                .frame(width: self.cropSize, height: self.cropSize)
                .blendMode(.destinationOut)
        }
        .compositingGroup()
        .overlay(
            ZStack {
                Rectangle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: self.cropSize, height: self.cropSize)

                GridLinesView(cropSize: self.cropSize)
            }
        )
        .allowsHitTesting(false)
        .enableInjection()
    }
}

private struct GridLinesView: View {
    @ObserveInjection var inject
    let cropSize: CGFloat

    var body: some View {
        let cropRect = CGRect(x: 0, y: 0, width: self.cropSize, height: self.cropSize)
        let lineWidth: CGFloat = 1

        ZStack {
            Path { path in
                let verticalSpacing = cropRect.width / 3
                path.move(to: CGPoint(x: verticalSpacing, y: 0))
                path.addLine(to: CGPoint(x: verticalSpacing, y: cropRect.height))
                path.move(to: CGPoint(x: verticalSpacing * 2, y: 0))
                path.addLine(to: CGPoint(x: verticalSpacing * 2, y: cropRect.height))
            }
            .stroke(Color.white.opacity(0.8), lineWidth: lineWidth)

            Path { path in
                let horizontalSpacing = cropRect.height / 3
                path.move(to: CGPoint(x: 0, y: horizontalSpacing))
                path.addLine(to: CGPoint(x: cropRect.width, y: horizontalSpacing))
                path.move(to: CGPoint(x: 0, y: horizontalSpacing * 2))
                path.addLine(to: CGPoint(x: cropRect.width, y: horizontalSpacing * 2))
            }
            .stroke(Color.white.opacity(0.8), lineWidth: lineWidth)
        }
        .frame(width: self.cropSize, height: self.cropSize)
        .enableInjection()
    }
}
