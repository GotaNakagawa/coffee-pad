import Inject
import SwiftUI

struct ExtractionCreateStepFlow: View {
    @ObserveInjection var inject
    @Binding var steps: [String]
    @State private var showSheet = false
    @State private var draggedItem: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ドリップの流れを追加")
                .font(.title)
                .bold()

            ExtractionCreateStepList(steps: self.$steps, draggedItem: self.$draggedItem)

            Spacer()

            ExtractionCreateStepAddButton(steps: self.$steps, showSheet: self.$showSheet)
        }
        .padding()
        .enableInjection()
    }
}

private struct ExtractionCreateStepList: View {
    @Binding var steps: [String]
    @Binding var draggedItem: String?

    var body: some View {
        if self.steps.isEmpty {
            Text("＋ボタンから手順を追加してください")
                .foregroundColor(.gray)
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(self.steps, id: \.self) { step in
                        Text("・\(step)")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                            .onDrag {
                                self.draggedItem = step
                                return NSItemProvider(object: step as NSString)
                            }
                            .onDrop(
                                of: [.text],
                                delegate: StepDropDelegate(
                                    item: step,
                                    steps: self.$steps,
                                    draggedItem: self.$draggedItem
                                )
                            )
                    }
                }
            }
        }
    }
}

struct StepDropDelegate: DropDelegate {
    let item: String
    @Binding var steps: [String]
    @Binding var draggedItem: String?

    func performDrop(info _: DropInfo) -> Bool {
        self.draggedItem = nil
        return true
    }

    func dropEntered(info _: DropInfo) {
        guard let draggedItem, draggedItem != item,
              let fromIndex = steps.firstIndex(of: draggedItem),
              let toIndex = steps.firstIndex(of: item) else { return }

        withAnimation {
            self.steps.move(
                fromOffsets: IndexSet(integer: fromIndex),
                toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex
            )
        }
    }
}

private struct ExtractionCreateStepAddButton: View {
    @Binding var steps: [String]
    @Binding var showSheet: Bool

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.showSheet = true
            }, label: {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(width: 56, height: 56)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding()
            })
            .sheet(isPresented: self.$showSheet) {
                ExtractionCreateStepSelectionSheet { selectedStep in
                    self.steps.append(selectedStep)
                    self.showSheet = false
                }
            }
        }
    }
}
