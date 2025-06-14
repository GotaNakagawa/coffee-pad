import Inject
import SwiftUI

struct ImageCropSectionView: View {
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

struct ImageCropView: View {
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
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged(self.onDragChanged)
                            .onEnded(self.onDragEnded)
                    )
                    .simultaneousGesture(
                        MagnificationGesture()
                            .onChanged(self.onMagnificationChanged)
                            .onEnded(self.onMagnificationEnded)
                    )
            }
            .frame(height: 350)
            .clipped()

            CropOverlayView(cropSize: self.cropSize)
        }
        .enableInjection()
    }
}

struct CropOverlayView: View {
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

struct GridLinesView: View {
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
