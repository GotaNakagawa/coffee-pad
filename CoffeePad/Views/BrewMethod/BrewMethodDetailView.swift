import Inject
import SwiftUI

struct BrewMethodDetailView: View {
    @ObserveInjection var inject
    let method: BrewMethod
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToEdit = false

    var body: some View {
        VStack(spacing: 0) {
            self.navigationBackButton
            self.contentScrollView
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: self.$navigateToEdit) {
            CreateBrewMethodView(editingMethod: self.method)
        }
        .enableInjection()
    }

    private func deleteMethod() {
        if let data = UserDefaults.standard.data(forKey: "brewMethods"),
           var methods = try? JSONDecoder().decode([BrewMethod].self, from: data) {
            methods.removeAll { $0.id == self.method.id }
            if let encoded = try? JSONEncoder().encode(methods) {
                UserDefaults.standard.set(encoded, forKey: "brewMethods")
            }
        }
        self.dismiss()
    }

    private var navigationBackButton: some View {
        HStack {
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 20)
                .padding(.leading, 20)
                .onTapGesture {
                    self.dismiss()
                }
            Spacer()
            Menu(
                content: {
                    Button(
                        action: { print("共有が選択されました") },
                        label: {
                            Label("共有", systemImage: "square.and.arrow.up")
                        }
                    )
                    Button(
                        action: { print("保存が選択されました") },
                        label: {
                            Label("保存", systemImage: "square.and.arrow.down")
                        }
                    )
                    Button(
                        role: .destructive,
                        action: { self.deleteMethod() },
                        label: {
                            Label("削除", systemImage: "trash")
                        }
                    )
                },
                label: {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .frame(width: 44, height: 44)
                        .foregroundColor(.primary)
                }
            )
            .padding(.trailing, 20)
        }
        .padding(.top, 24)
        .padding(.bottom, 8)
    }

    private var contentScrollView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                    .frame(height: 16)
                self.heroImageSection
                self.titleSection
                self.actionButtonsSection
                BrewMethodDetailsSection(method: self.method)
                    .padding(.top, 20)
            }
        }
    }

    private var heroImageSection: some View {
        HStack {
            Spacer()
            BrewMethodIconView(iconData: self.method.iconData, size: 250, radius: 12)
            Spacer()
        }
    }

    private var titleSection: some View {
        VStack(alignment: .center) {
            Text(self.method.title)
                .font(.title)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var actionButtonsSection: some View {
        HStack(spacing: 16) {
            self.playButton
            self.editButton
        }
        .padding(.horizontal, 20)
    }

    private var playButton: some View {
        Button(
            action: {
                print("再生ボタンがタップされました")
            },
            label: {
                HStack {
                    Image(systemName: "play.fill")
                        .font(.title3)
                    Text("再生")
                        .font(.body)
                        .bold()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color("DeepGreen"))
                .cornerRadius(8)
            }
        )
    }

    private var editButton: some View {
        Button(
            action: {
                self.navigateToEdit = true
            },
            label: {
                HStack {
                    Image(systemName: "shuffle")
                        .font(.title3)
                    Text("編集")
                        .font(.body)
                        .bold()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color("DeepGreen"))
                .cornerRadius(8)
            }
        )
    }
}
