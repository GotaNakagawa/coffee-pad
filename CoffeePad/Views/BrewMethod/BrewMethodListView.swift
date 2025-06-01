import Inject
import SwiftUI

struct BrewMethodListView: View {
    @ObserveInjection var inject
    @Environment(\.dismiss) private var dismiss

    @State private var methods: [BrewMethod] = []

    let colors: [Color] = [
        Color("DeepGreen"),
        Color("LightBeige"),
        Color("DarkBrown"),
        Color("DarkBrown")
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 16) {
                BrewMethodListHeader()

                Spacer()

                BrewMethodListStats(methods: self.methods)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(Array(self.methods.enumerated()), id: \.1.id) { index, method in
                            let color = self.colors[index % self.colors.count]
                            BrewMethodRow(method: method, color: color)
                        }
                    }
                }
            }
            .padding()

            NavigationLink(destination: CreateBrewMethodView()) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(Color.primary)
                    .frame(width: 56, height: 56)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding()
            }
        }
        .navigationBarHidden(true)
        .enableInjection()
        .onAppear {
            if let data = UserDefaults.standard.data(forKey: "brewMethods"),
               let saved = try? JSONDecoder().decode([BrewMethod].self, from: data) {
                self.methods = saved
            }
        }
    }
}
