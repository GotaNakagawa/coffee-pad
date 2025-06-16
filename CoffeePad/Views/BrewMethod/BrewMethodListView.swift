import Inject
import SwiftUI

enum SortOrder {
    case newest // 新しい順
    case oldest // 古い順
}

struct BrewMethodListView: View {
    @ObserveInjection var inject
    @Environment(\.dismiss) private var dismiss

    @State private var methods: [BrewMethod] = []
    @State private var sortOrder: SortOrder = .newest

    let colors: [Color] = [
        Color("DeepGreen"),
        Color("LightBeige"),
        Color("DarkBrown")
    ]

    var sortedMethods: [BrewMethod] {
        switch self.sortOrder {
        case .newest:
            self.methods.sorted { $0.id > $1.id }
        case .oldest:
            self.methods.sorted { $0.id < $1.id }
        }
    }

    var statsWithSortButtons: some View {
        HStack {
            BrewMethodListStats(methods: self.methods)

            Spacer()

            Button(
                action: {
                    self.sortOrder = self.sortOrder == .oldest ? .newest : .oldest
                },
                label: {
                    HStack(spacing: 4) {
                        Text(self.sortOrder == .newest ? "新しい順" : "古い順")
                            .bold()
                            .foregroundColor(Color("DeepGreen"))
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(Color("DeepGreen"))
                    }
                }
            )
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 16) {
                BrewMethodListHeader()

                Spacer()

                self.statsWithSortButtons

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(Array(self.sortedMethods.enumerated()), id: \.1.id) { index, method in
                            let color = self.colors[index % self.colors.count]
                            BrewMethodRow(
                                method: method,
                                color: color
                            ) { methodId in
                                self.deleteMethod(id: methodId)
                            }
                        }
                    }
                }
            }
            .padding()

            HStack {
                NavigationLink(destination: YouTubeBrewMethodCreateView()) {
                    HStack {
                        Image(systemName: "play.rectangle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                        Text("YouTubeから作成")
                            .foregroundColor(.primary)
                            .font(.body)
                    }
                    .frame(height: 56)
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }
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

    private func deleteMethod(id: Int) {
        self.methods.removeAll { $0.id == id }

        if let encoded = try? JSONEncoder().encode(self.methods) {
            UserDefaults.standard.set(encoded, forKey: "brewMethods")
        }
    }
}
