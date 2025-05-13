import SwiftUI

struct IceStepDetailView: View {
    @Binding var amount: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("氷の量 (g)")
            
            Picker("量", selection: $amount) {
                ForEach(0...100, id: \.self) { value in
                    Text("\(value) g").tag(value)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 100)
        }
    }
}
