import SwiftUI

struct StirStepDetailView: View {
    @Binding var duration: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("かき混ぜる時間 (秒)")
            
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
