import SwiftUI
import Inject

struct ExtractionCreateView: View {
    @ObserveInjection var inject
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    private let totalSteps = 4

    @State private var methodName: String = ""
    @State private var grindSize: String = "中挽き"
    @State private var coffeeAmount: String = ""
    @State private var waterTemp: String = ""

    let grindOptions = ["極細挽き", "細挽き", "中挽き", "粗挽き", "極粗挽き"]
    
    var canProceedToNextStep: Bool {
        switch currentStep {
        case 0:
            return !methodName.trimmingCharacters(in: .whitespaces).isEmpty
        case 1:
            return !grindSize.isEmpty
        case 2:
            return Int(coffeeAmount) != nil
        case 3:
            return Int(waterTemp) != nil
        default:
            return true
        }
    }


    var body: some View {
        VStack(spacing: 20) {
            ProgressView(value: Double(currentStep + 1), total: Double(totalSteps))
                .progressViewStyle(LinearProgressViewStyle(tint: Color("DarkBrown")))
                .padding(.horizontal)
            
            HStack {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 20)
                    .padding(.leading, 20)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
            }

            Group {
                switch currentStep {
                case 0:
                    StepTextFieldView(
                        title: "抽出メソッド名は",
                        description: "オリジナルの名前をつけましょう",
                        text: $methodName,
                        placeholder: "例: マイルドドリップ"
                    )
                case 1:
                    StepPickerView(
                        title: "豆のひき目",
                        description: "使用するコーヒー豆の挽き方を選んでください",
                        selection: $grindSize,
                        options: grindOptions
                    )
                case 2:
                    StepTextFieldView(
                        title: "粉の量",
                        description: "グラムで入力してください",
                        text: $coffeeAmount,
                        placeholder: "15",
                        keyboardType: .numberPad
                    )
                case 3:
                    StepTextFieldView(
                        title: "お湯の温度は？",
                        description: "温度を℃で入力してください",
                        text: $waterTemp,
                        placeholder: "90",
                        keyboardType: .numberPad
                    )
                default:
                    Text("完了！")
                }
            }
            .animation(.easeInOut, value: currentStep)
            
            Spacer()

            Button(action: {
                if currentStep < totalSteps - 1 {
                    currentStep += 1
                } else {
                    print("作成完了: \(methodName), \(grindSize), \(coffeeAmount)g, \(waterTemp)℃")
                }
            }) {
                Text(currentStep == totalSteps - 1 ? "完了" : "次へ")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canProceedToNextStep ? Color("DarkBrown") : Color("DarkBrown").opacity(0.3))

                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(!canProceedToNextStep)
            .padding(.bottom, 24)


        }
        .navigationBarBackButtonHidden(true)
        .enableInjection()
    }
}
