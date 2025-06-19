import Inject
import PhotosUI
import SwiftUI

struct CreateBrewMethodIconSelection: View {
    @ObserveInjection var inject
    let title: String
    let description: String
    @Binding var selectedIconData: Data?
    @ObservedObject var photoHandler: PhotoSelectionHandler

    private enum Constants {
        static let cropSize: CGFloat = 280
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            self.headerSection

            if let selectedImage = self.photoHandler.selectedUIImage {
                ScrollView {
                    VStack(spacing: 20) {
                        self.imageCropSection(image: selectedImage)
                        CropActionButtons(
                            selectedItem: self.$photoHandler.selectedItem,
                            onComplete: {
                                if let imageData = self.photoHandler.completeCropping() {
                                    self.selectedIconData = imageData
                                }
                            },
                            canComplete: self.photoHandler.isCropAreaCompletelyWithinImage(),
                            onImageChange: {
                                await self.photoHandler.handleImageSelection(
                                    self.photoHandler.selectedItem,
                                    existingImageData: self.selectedIconData
                                )
                            }
                        )
                    }
                    .padding(.bottom, 20)
                }
            } else {
                ImagePreviewCard(selectedIconData: self.selectedIconData)
                PhotoPickerButton(
                    selectedItem: self.$photoHandler.selectedItem
                ) {
                    await self.photoHandler.handleImageSelection(
                        self.photoHandler.selectedItem,
                        existingImageData: self.selectedIconData
                    )
                }
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .onChange(of: self.photoHandler.selectedItem) { _, newItem in
            if newItem != nil {
                self.photoHandler.startImageSelection()
                DispatchQueue.main.async {
                    self.photoHandler.objectWillChange.send()
                }
            }
        }
        .enableInjection()
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

    private func imageCropSection(image: UIImage) -> some View {
        ImageCropSectionView(
            image: image,
            scale: self.photoHandler.scale,
            cropOffset: self.photoHandler.cropOffset,
            cropSize: Constants.cropSize,
            onDragChanged: self.photoHandler.handleDragChanged,
            onDragEnded: self.photoHandler.handleDragEnded,
            onMagnificationChanged: self.photoHandler.handleMagnificationChanged,
            onMagnificationEnded: self.photoHandler.handleMagnificationEnded
        )
    }
}
