import SwiftUI

struct WaitStepDetailView: View {
    @Binding var duration: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("待つ時間 (秒)")
            
            Picker("時間", selection: $duration) {
                ForEach(0...300, id: \.self) { value in
                    Text("\(value) 秒").tag(value)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 100)
        }
    }
}
