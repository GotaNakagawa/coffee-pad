import SwiftUI

struct BrewMethodRow: View {
    let method: BrewMethod
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(self.color)
                .shadow(radius: 4)

            VStack(spacing: 0) {
                BrewMethodDetails(method: self.method)

                HStack {
                    Text(self.method.date)
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

private struct BrewMethodDetails: View {
    let method: BrewMethod

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.method.title)
                .font(.headline)

            Text(self.method.comment)
                .font(.caption)
                .foregroundColor(.gray)

            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image("coffeeCupIcon")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("\(self.method.amount)ml")
                }

                HStack(spacing: 4) {
                    Image("groundCoffeeIcon")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text(self.method.grind)
                }

                HStack(spacing: 4) {
                    Image("thermometerIcon")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("\(self.method.temp)℃")
                }

                HStack(spacing: 4) {
                    Image("scaleIcon")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("\(self.method.weight)g")
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
    }
}
