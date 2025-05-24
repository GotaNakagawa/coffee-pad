import SwiftUI
import Inject

struct ExtractionListView: View {
    @ObserveInjection var inject
    @Environment(\.dismiss) private var dismiss

    let methods: [ExtractionMethod] = [
        .init(id: 1, title: "メソッド名", comment: "備考", amount: 200, grind: "中挽き", temp: 95, weight: 225, date: "4月18日 金曜日"),
        .init(id: 2, title: "メソッド名", comment: "備考", amount: 200, grind: "中挽き", temp: 95, weight: 225, date: "4月18日 金曜日"),
        .init(id: 3, title: "メソッド名", comment: "備考", amount: 200, grind: "中挽き", temp: 95, weight: 225, date: "2月18日 金曜日"),
        .init(id: 4, title: "メソッド名", comment: "備考", amount: 200, grind: "中挽き", temp: 95, weight: 225, date: "4月18日 金曜日"),
        .init(id: 5, title: "メソッド名", comment: "備考", amount: 200, grind: "中挽き", temp: 95, weight: 225, date: "4月18日 金曜日"),
        .init(id: 6, title: "メソッド名", comment: "備考", amount: 200, grind: "中挽き", temp: 95, weight: 225, date: "2月18日 金曜日")
    ]

    let colors: [Color] = [
        Color("DeepGreen"),
        Color("LightBeige"),
        Color("DarkBrown"),
        Color("DarkBrown")
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 16) {
                ExtractionListHeader()
                
                Spacer()
                
                ExtractionStatsView()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(Array(methods.enumerated()), id: \.1.id) { index, method in
                            let color = colors[index % colors.count]
                            ExtractionMethodRow(method: method, color: color)
                        }
                    }
                }
            }
            .padding()

            NavigationLink(destination: ExtractionCreateView()) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(width: 56, height: 56)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding()
            }
        }
        .navigationBarHidden(true)
        .enableInjection()
    }
}

struct ExtractionStatsView: View {
    var body: some View {
        HStack(spacing: 16) {
            VStack {
                Text("2件").bold()
                Text("今月の作成数").font(.caption).foregroundColor(.gray)
            }

            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 1, height: 30)
                .cornerRadius(0.5)

            VStack {
                Text("3件").bold()
                Text("総作成数").font(.caption).foregroundColor(.gray)
            }
        }
    }
}

struct ExtractionListHeader: View {
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
                    dismiss()
                },
            alignment: .leading
        )
        .padding(.top, 16)
    }
}

struct ExtractionMethodRow: View {
    let method: ExtractionMethod
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(color)
                .shadow(radius: 4)

            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(method.title)
                        .font(.headline)

                    Text(method.comment)
                        .font(.caption)
                        .foregroundColor(.gray)

                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image("coffeeCupIcon")
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text("\(method.amount)ml")
                        }

                        HStack(spacing: 4) {
                            Image("groundCoffeeIcon")
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text(method.grind)
                        }

                        HStack(spacing: 4) {
                            Image("thermometerIcon")
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text("\(method.temp)℃")
                        }

                        HStack(spacing: 4) {
                            Image("scaleIcon")
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text("\(method.weight)g")
                        }
                    }
                    .font(.caption)

                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 1)
                .padding(.horizontal, 8)
                .padding(.top, 8)
                .padding(.bottom, 8)

                HStack {
                    Text(method.date)
                        .font(.footnote)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 4) {
                        Circle().frame(width: 4, height: 4).foregroundColor(.white.opacity(0.8))
                        Circle().frame(width: 4, height: 4).foregroundColor(.white.opacity(0.8))
                        Circle().frame(width: 4, height: 4).foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct ExtractionMethod: Identifiable {
    let id: Int
    let title: String
    let comment: String
    let amount: Int
    let grind: String
    let temp: Int
    let weight: Int
    let date: String
}
