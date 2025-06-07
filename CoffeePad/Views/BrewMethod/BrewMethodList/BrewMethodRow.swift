import Inject
import SwiftUI

struct BrewMethodRow: View {
    @ObserveInjection var inject
    let method: BrewMethod
    let color: Color
    @State private var showingActionSheet = false

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
                    Button(action: {
                        self.showingActionSheet = true
                    }, label: {
                        HStack(spacing: 4) {
                            Circle().frame(width: 4, height: 4).foregroundColor(.white.opacity(0.8))
                            Circle().frame(width: 4, height: 4).foregroundColor(.white.opacity(0.8))
                            Circle().frame(width: 4, height: 4).foregroundColor(.white.opacity(0.8))
                        }
                    })
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: self.$showingActionSheet) {
            BrewMethodActionSheet(method: self.method)
        }
        .enableInjection()
    }
}

private struct BrewMethodDetails: View {
    @ObserveInjection var inject
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
        .enableInjection()
    }
}

struct BrewMethodActionSheet: View {
    let method: BrewMethod
    @Environment(\.dismiss) private var dismiss
    @State private var contentHeight: CGFloat = 200

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 8)
                .padding(.bottom, 8)

            HStack(spacing: 12) {
                Button(action: {
                    self.shareBrewMethod()
                }, label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 80)
                        .overlay {
                            VStack(spacing: 4) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title3)
                                    .foregroundColor(.black)
                                Text("共有")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }
                })

                Button(action: {
                    self.saveBrewMethod()
                }, label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 80)
                        .overlay {
                            VStack(spacing: 4) {
                                Image(systemName: "square.and.arrow.down")
                                    .font(.title3)
                                    .foregroundColor(.black)
                                Text("保存")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }
                })
            }
            .padding(20)

            Button(action: {
                self.deleteBrewMethod()
            }, label: {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                    Text("メッセージを削除")
                        .foregroundColor(.red)
                        .font(.body)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.15))
                .cornerRadius(12)
            })
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color(.systemBackground))
        .cornerRadius(40)
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        self.contentHeight = geometry.size.height
                    }
            }
        )
        .presentationDetents([.height(self.contentHeight)])
        .presentationDragIndicator(.hidden)
    }

    private func shareBrewMethod() {
        print("共有が選択されました")
        self.dismiss()
    }

    private func saveBrewMethod() {
        print("保存が選択されました")
        self.dismiss()
    }

    private func deleteBrewMethod() {
        print("削除が選択されました")
        self.dismiss()
    }
}
