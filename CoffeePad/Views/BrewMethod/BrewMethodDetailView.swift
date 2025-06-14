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
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.cyan.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 250, height: 250)
                .overlay(
                    Group {
                        if let iconData = self.method.iconData,
                           let uiImage = UIImage(data: iconData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 250, height: 250)
                                .clipped()
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        } else {
                            Text("RWS")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                )
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
