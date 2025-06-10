import Inject
import SwiftUI

struct BrewMethodListStats: View {
    @ObserveInjection var inject
    let methods: [BrewMethod]

    var totalCount: Int {
        self.methods.count
    }

    var thisMonthCount: Int {
        let calendar = Calendar.current
        let now = Date()
        return self.methods.count { method in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            if let methodDate = formatter.date(from: method.date) {
                return calendar.isDate(methodDate, equalTo: now, toGranularity: .month)
            }
            return false
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            VStack {
                Text("\(self.thisMonthCount)件").bold()
                Text("今月の作成数").font(.caption).foregroundColor(.gray)
            }

            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 1, height: 30)
                .cornerRadius(0.5)

            VStack {
                Text("\(self.totalCount)件").bold()
                Text("総作成数").font(.caption).foregroundColor(.gray)
            }
        }
        .enableInjection()
    }
}
