import Inject
import SwiftUI

struct BrewMethodRow: View {
    @ObserveInjection var inject
    let method: BrewMethod
    let color: Color
    let onDelete: (Int) -> Void
    @State private var showingActionSheet = false

    var body: some View {
        NavigationLink(destination: BrewMethodDetailView(method: self.method)) {
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
                            .padding(8)
                        })
                    }
                    .padding(.vertical, 16)
                    .padding(.leading, 16)
                    .padding(.trailing, 8)
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: self.$showingActionSheet) {
            BrewMethodActionSheet(method: self.method, onDelete: self.onDelete)
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

            Text(self.method.comment.components(separatedBy: .newlines).first ?? "")
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
    @ObserveInjection var inject
    let method: BrewMethod
    let onDelete: (Int) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var contentHeight: CGFloat = 200

    var body: some View {
        VStack(spacing: 0) {
            self.dragIndicator
            self.actionButtonsSection
            self.deleteButtonSection
        }
        .background(Color(.systemBackground))
        .cornerRadius(40)
        .background(self.geometryBackground)
        .presentationDetents([.height(self.contentHeight)])
        .presentationDragIndicator(.hidden)
        .enableInjection()
    }

    private var dragIndicator: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 40, height: 4)
            .padding(.top, 8)
            .padding(.bottom, 8)
    }

    private var actionButtonsSection: some View {
        HStack(spacing: 12) {
            self.shareButton
            self.saveButton
        }
        .padding(20)
    }

    private var shareButton: some View {
        Button(
            action: {
                self.shareBrewMethod()
            },
            label: {
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
            }
        )
    }

    private var saveButton: some View {
        Button(
            action: {
                self.saveBrewMethod()
            },
            label: {
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
            }
        )
    }

    private var deleteButtonSection: some View {
        Button(
            action: {
                self.deleteBrewMethod()
            },
            label: {
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
            }
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }

    private var geometryBackground: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    self.contentHeight = geometry.size.height
                }
        }
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
        self.onDelete(self.method.id)
        self.dismiss()
    }
}
