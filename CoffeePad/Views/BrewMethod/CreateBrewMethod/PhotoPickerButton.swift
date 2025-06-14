import Inject
import PhotosUI
import SwiftUI

struct PhotoPickerButton: View {
    @ObserveInjection var inject
    @Binding var selectedItem: PhotosPickerItem?
    let buttonText: String
    let backgroundColor: Color
    let foregroundColor: Color
    let onSelection: () async -> Void

    init(
        selectedItem: Binding<PhotosPickerItem?>,
        buttonText: String = "画像を変更する",
        backgroundColor: Color = Color("DeepGreen"),
        foregroundColor: Color = .white,
        onSelection: @escaping () async -> Void = {}
    ) {
        self._selectedItem = selectedItem
        self.buttonText = buttonText
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.onSelection = onSelection
    }

    var body: some View {
        PhotosPicker(
            selection: self.$selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            HStack {
                Image(systemName: "photo.on.rectangle")
                    .font(.title3)
                Text(self.buttonText)
                    .font(.body)
                    .bold()
            }
            .foregroundColor(self.foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(self.backgroundColor)
            .cornerRadius(8)
        }
        .onChange(of: self.selectedItem) { _, _ in
            Task {
                await self.onSelection()
            }
        }
        .enableInjection()
    }
}

struct ImagePreviewCard: View {
    @ObserveInjection var inject
    let selectedIconData: Data?
    let size: CGFloat

    init(selectedIconData: Data?, size: CGFloat = 200) {
        self.selectedIconData = selectedIconData
        self.size = size
    }

    var body: some View {
        HStack {
            Spacer()
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .aspectRatio(1, contentMode: .fit)
                .frame(width: self.size, height: self.size)
                .overlay(self.content)
            Spacer()
        }
        .enableInjection()
    }

    @ViewBuilder
    private var content: some View {
        if let iconData = selectedIconData,
           let uiImage = UIImage(data: iconData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: self.size, height: self.size)
                .clipped()
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
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
}

struct CropActionButtons: View {
    @ObserveInjection var inject
    @Binding var selectedItem: PhotosPickerItem?
    let onComplete: () -> Void
    let canComplete: Bool
    let onImageChange: () async -> Void

    var body: some View {
        HStack(spacing: 16) {
            PhotoPickerButton(
                selectedItem: self.$selectedItem,
                buttonText: "画像を変更",
                backgroundColor: Color(.systemGray6),
                foregroundColor: .secondary,
                onSelection: self.onImageChange
            )

            Button(
                action: {
                    if self.canComplete {
                        self.onComplete()
                    }
                },
                label: {
                    Text("完了")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(self.canComplete ? Color("DeepGreen") : Color("DeepGreen").opacity(0.3))
                        .cornerRadius(8)
                }
            )
            .disabled(!self.canComplete)
        }
        .enableInjection()
    }
}
