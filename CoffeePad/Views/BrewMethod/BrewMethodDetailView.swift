import Inject
import SwiftUI

struct BrewMethodDetailView: View {
    @ObserveInjection var inject
    let method: BrewMethod
    @Environment(\.dismiss) private var dismiss

    var body: some View {
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
        .padding(.top, 16)
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
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
                            Text("RWS")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                        )
                    Spacer()
                }

                VStack(alignment: .center) {
                    Text(self.method.title)
                        .font(.title)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)

                HStack(spacing: 16) {
                    Button(action: {
                        print("再生ボタンがタップされました")
                    }) {
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

                    Button(action: {
                        print("編集ボタンがタップされました")
                    }) {
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
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .enableInjection()
    }
}
