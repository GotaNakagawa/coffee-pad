import SwiftUI

struct PourStepDetailView: View {
    @Binding var selectedCircle: PourCircleSize
    @Binding var amount: Int
    @Binding var duration: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("注ぐ円の大きさ")
            Picker("円", selection: $selectedCircle) {
                ForEach(PourCircleSize.allCases) { size in
                    Text(size.rawValue).tag(size)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            Text("注ぐ量 (g)")
            Picker("注ぐ量", selection: $amount) {
                ForEach(0...100, id: \.self) { value in
                    Text("\(value) g").tag(value)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 100)

            Text("時間 (秒)")
            Picker("時間", selection: $duration) {
                ForEach(0...60, id: \.self) { value in
                    Text("\(value) 秒").tag(value)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 100)
        }
    }
}
