import Inject
import SwiftUI

struct HomeView: View {
    @ObserveInjection var inject
    @State private var selectedPage = 0
    let carouselImages = ["mainImage", "mainImage", "mainImage"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HomeHeader()

                HomeCarousel(selectedPage: self.$selectedPage, images: self.carouselImages)

                HomeMenuGrid()

                Spacer()
            }
            .padding(.top, 16)
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
        }
        .enableInjection()
    }
}

private struct HomeHeader: View {
    var body: some View {
        ZStack {
            Text("Coffee Pad")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .overlay(
            Image("hamburgerIcon")
                .resizable()
                .renderingMode(.original)
                .frame(width: 18, height: 14)
                .padding(.leading, 16),
            alignment: .leading
        )
        .padding(.top, 16)
    }
}

private struct HomeCarousel: View {
    @Binding var selectedPage: Int
    let images: [String]

    var body: some View {
        VStack(spacing: 12) {
            TabView(selection: self.$selectedPage) {
                ForEach(self.images.indices, id: \.self) { index in
                    ZStack(alignment: .bottomLeading) {
                        Image(self.images[index])
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .cornerRadius(20)
                            .padding(.horizontal, 20)
                            .tag(index)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Days Coffee Roasterが")
                            Text("新作のエスプレッソクラフトコーラを始めました")
                        }
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .padding(.leading, 20)
                        .padding(.bottom, 16)
                    }
                    .frame(
                        width: UIScreen.main.bounds.width - 40,
                        height: UIScreen.main.bounds.width - 40
                    )
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: UIScreen.main.bounds.width - 40)

            HStack(spacing: 6) {
                ForEach(self.images.indices, id: \.self) { index in
                    Circle()
                        .fill(index == self.selectedPage ? Color.black : Color.gray.opacity(0.4))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
}

private struct HomeMenuGrid: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 24) {
            NavigationLink(destination: BrewMethodListView()) {
                MenuButton(title: "抽出メソッド", imageName: "methodIcon", backgroundColor: Color("DeepGreen"))
            }
            MenuButton(title: "テイスティング", imageName: "tastingIcon", backgroundColor: Color("LightBeige"))
            MenuButton(title: "コーヒー生豆", imageName: "greenBeanIcon", backgroundColor: Color("DarkBrown"))
            MenuButton(title: "焙煎コーヒー豆", imageName: "roastedBeanIcon", backgroundColor: Color("LightBeige"))
            MenuButton(title: "タイマー", imageName: "timerIcon", backgroundColor: Color("DarkBrown"))
        }
        .padding(.horizontal, 20)
    }
}
