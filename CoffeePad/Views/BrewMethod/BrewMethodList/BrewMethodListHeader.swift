import SwiftUI

struct BrewMethodListHeader: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Text("抽出メソッド")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .overlay(
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 20)
                .padding(.leading, 6)
                .onTapGesture {
                    self.dismiss()
                },
            alignment: .leading
        )
        .padding(.top, 16)
    }
}
