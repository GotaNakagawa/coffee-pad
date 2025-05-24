import Inject
import SwiftUI

struct BrewStepFlowView: View {
    @ObserveInjection var inject
    @Binding var steps: [String]
    @State private var showSheet = false
    @State private var draggedItem: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ドリップの流れを追加")
                .font(.title)
                .bold()

            if steps.isEmpty {
                Text("＋ボタンから手順を追加してください")
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(steps, id: \.self) { step in
                            Text("・\(step)")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                                .onDrag {
                                    draggedItem = step
                                    return NSItemProvider(object: step as NSString)
                                }
                                .onDrop(of: [.text], delegate: StepDropDelegate(item: step, steps: $steps, draggedItem: $draggedItem))
                        }
                    }
                }
            }

            Spacer()

            HStack {
                Spacer()
                Button(action: { showSheet = true }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(width: 56, height: 56)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        .padding()
                }
                .sheet(isPresented: $showSheet) {
                    BrewStepSelectionSheet { selectedStep in
                        steps.append(selectedStep)
                        showSheet = false
                    }
                }
            }
        }
        .padding()
        .enableInjection()
    }
}

struct StepDropDelegate: DropDelegate {
    let item: String
    @Binding var steps: [String]
    @Binding var draggedItem: String?

    func performDrop(info _: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }

    func dropEntered(info _: DropInfo) {
        guard let draggedItem, draggedItem != item,
              let fromIndex = steps.firstIndex(of: draggedItem),
              let toIndex = steps.firstIndex(of: item) else { return }

        withAnimation {
            steps.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
}
