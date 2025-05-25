import Inject
import SwiftUI

struct ExtractionListView: View {
    @ObserveInjection var inject
    @Environment(\.dismiss) private var dismiss

    let methods: [ExtractionMethod] = [
        .init(
            id: 1,
            title: "メソッド名",
            comment: "備考",
            amount: 200,
            grind: "中挽き",
            temp: 95,
            weight: 225,
            date: "4月18日 金曜日"
        ),
        .init(
            id: 2,
            title: "メソッド名",
            comment: "備考",
            amount: 200,
            grind: "中挽き",
            temp: 95,
            weight: 225,
            date: "4月18日 金曜日"
        ),
        .init(
            id: 3,
            title: "メソッド名",
            comment: "備考",
            amount: 200,
            grind: "中挽き",
            temp: 95,
            weight: 225,
            date: "2月18日 金曜日"
        ),
        .init(
            id: 4,
            title: "メソッド名",
            comment: "備考",
            amount: 200,
            grind: "中挽き",
            temp: 95,
            weight: 225,
            date: "4月18日 金曜日"
        ),
        .init(
            id: 5,
            title: "メソッド名",
            comment: "備考",
            amount: 200,
            grind: "中挽き",
            temp: 95,
            weight: 225,
            date: "4月18日 金曜日"
        ),
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

                ExtractionStats()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(Array(self.methods.enumerated()), id: \.1.id) { index, method in
                            let color = self.colors[index % self.colors.count]
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
