import SwiftUI
import Inject

struct HomeView: View {
    @ObserveInjection var inject
    @State private var selectedPage = 0
    let carouselImages = ["mainImage", "mainImage", "mainImage"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Image("hamburgerIcon")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 18, height: 14)
                        .padding(.leading)
                        .padding(.leading, -10)

                    Spacer()

                    Text("Coffee Pad")
                        .font(.title2)
                        .fontWeight(.bold)

                    Spacer()

                    Color.clear.frame(width: 30)
                }
                .padding(.top, 16)
                .padding(.horizontal)

                TabView(selection: $selectedPage) {
                    ForEach(carouselImages.indices, id: \.self) { index in
                        ZStack(alignment: .bottomLeading) {
                            Image(carouselImages[index])
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
                        .frame(width: UIScreen.main.bounds.width - 40,
                               height: UIScreen.main.bounds.width - 40)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: UIScreen.main.bounds.width - 40)

                HStack(spacing: 6) {
                    ForEach(carouselImages.indices, id: \.self) { index in
                        Circle()
                            .fill(index == selectedPage ? Color.black : Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 24) {
                    MenuButton(title: "抽出メソッド", imageName: "methodIcon", backgroundColor: Color("DeepGreen"))
                    MenuButton(title: "テイスティング", imageName: "tastingIcon", backgroundColor: Color("LightBeige"))
                    MenuButton(title: "コーヒー生豆", imageName: "greenBeanIcon", backgroundColor: Color("DarkBrown"))
                    MenuButton(title: "焙煎コーヒー豆", imageName: "roastedBeanIcon", backgroundColor: Color("LightBeige"))
                    MenuButton(title: "タイマー", imageName: "timerIcon", backgroundColor: Color("DarkBrown"))
                }
                .padding(.horizontal, 20)

                Spacer(minLength: 40)
            }
            .padding(.top, 16)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .enableInjection()
    }
}

struct MenuButton: View {
    let title: String
    let imageName: String
    let backgroundColor: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .frame(width: 64, height: 64)
                    .shadow(radius: 4)

                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }

            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}
