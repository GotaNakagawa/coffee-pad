import Inject
import SwiftUI

struct BrewMethodDetailView: View {
    @ObserveInjection var inject
    let method: BrewMethod
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            self.navigationBackButton
            self.contentScrollView
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
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
        .padding(.top, 16)
    }

    private var contentScrollView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
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
                print("編集ボタンがタップされました")
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

    private struct BrewMethodDetailsSection: View {
        let method: BrewMethod

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                PrerequisitesSection(method: self.method)
                if !self.method.steps.isEmpty {
                    StepsSection(steps: self.method.steps)
                }
                if !self.method.comment.isEmpty {
                    CommentSection(comment: self.method.comment)
                }
            }
        }
    }

    private struct PrerequisitesSection: View {
        let method: BrewMethod

        private var totalTime: String {
            let totalSeconds = self.method.steps.compactMap(\.time).reduce(0, +)
            let minutes = totalSeconds / 60
            let seconds = totalSeconds % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                VStack(spacing: 0) {
                    DetailRowView(
                        imageName: "groundCoffeeIcon",
                        label: "挽き目の粒度",
                        value: self.method.grind,
                        memo: nil,
                        imageIsSystem: false,
                        isFirst: true,
                        isLast: false
                    )
                    DetailRowView(
                        imageName: "coffeeCupIcon",
                        label: "抽出量",
                        value: "\(self.method.amount)ml",
                        memo: nil,
                        imageIsSystem: false,
                        isFirst: false,
                        isLast: false
                    )
                    DetailRowView(
                        imageName: "thermometerIcon",
                        label: "お湯の温度",
                        value: "\(self.method.temp)℃",
                        memo: nil,
                        imageIsSystem: false,
                        isFirst: false,
                        isLast: false
                    )
                    DetailRowView(
                        imageName: "scaleIcon",
                        label: "コーヒー粉の重量",
                        value: "\(self.method.weight)g",
                        memo: nil,
                        imageIsSystem: false,
                        isFirst: false,
                        isLast: false
                    )
                    DetailRowView(
                        imageName: "timerIcon",
                        label: "抽出時間",
                        value: self.totalTime,
                        memo: nil,
                        imageIsSystem: false,
                        isFirst: false,
                        isLast: true
                    )
                }
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            }
        }
    }

    private struct StepsSection: View {
        let steps: [BrewStep]

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                VStack(spacing: 0) {
                    ForEach(Array(self.steps.enumerated()), id: \.element.id) { index, step in
                        StepRowView(
                            step: step,
                            stepNumber: index + 1,
                            isFirst: index == 0,
                            isLast: index == self.steps.count - 1
                        )
                    }
                }
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            }
        }
    }

    private struct CommentSection: View {
        let comment: String

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                VStack(spacing: 0) {
                    CommentRowView(comment: self.comment)
                }
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            }
        }
    }
}
