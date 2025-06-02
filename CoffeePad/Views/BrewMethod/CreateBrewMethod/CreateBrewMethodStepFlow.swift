import Inject
import SwiftUI

struct CreateBrewMethodStepFlow: View {
    @ObserveInjection var inject
    @Binding var steps: [BrewStep]
    @State private var showSheet = false
    @State private var draggedItem: BrewStep?

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("ドリップの流れを追加")
                    .font(.title)
                    .bold()
                CreateBrewMethodStepList(steps: self.$steps, draggedItem: self.$draggedItem)
            }
            .padding([.top, .leading])
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CreateBrewMethodStepAddButton(steps: self.$steps, showSheet: self.$showSheet)
                }
            }
        }
        .enableInjection()
    }
}

private struct CreateBrewMethodStepList: View {
    @Binding var steps: [BrewStep]
    @Binding var draggedItem: BrewStep?

    var body: some View {
        if self.steps.isEmpty {
            Text("＋ボタンから手順を追加してください")
                .foregroundColor(.gray)
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(self.steps) { step in
                        HStack(spacing: 12) {
                            Image(systemName: "drop.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color("DeepGreen"))
                            BrewStepInfoView(step: step)
                            Spacer()
                            Button(action: {
                                if let idx = self.steps.firstIndex(where: { $0.id == step.id }) {
                                    self.steps.remove(at: idx)
                                }
                            }, label: {
                                Image(systemName: "trash")
                                    .foregroundColor(Color.primary)
                            })
                            .buttonStyle(.plain)
                        }
                        .frame(height: 56)
                        .padding(.vertical, 4)
                        .padding(.horizontal)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("DarkBrown"), lineWidth: 3)
                        )
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .onDrag {
                            self.draggedItem = step
                            return NSItemProvider(object: NSString(string: step.id.uuidString))
                        }
                        .onDrop(
                            of: [.text],
                            delegate: StepDropDelegate(item: step, steps: self.$steps, draggedItem: self.$draggedItem)
                        )
                    }
                }
                .padding(.trailing, 12)
            }
        }
    }
}

struct StepDropDelegate: DropDelegate {
    let item: BrewStep
    @Binding var steps: [BrewStep]
    @Binding var draggedItem: BrewStep?

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

private struct CreateBrewMethodStepAddButton: View {
    @Binding var steps: [BrewStep]
    @Binding var showSheet: Bool

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.showSheet = true
            }, label: {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(Color.primary)
                    .frame(width: 56, height: 56)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding()
            })
            .sheet(isPresented: self.$showSheet) {
                CreateBrewMethodStepSelectionSheet { selectedStep in
                    self.steps.append(selectedStep)
                    self.showSheet = false
                }
            }
        }
    }
}

private struct BrewStepInfoView: View {
    let step: BrewStep
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(self.step.title)
                .font(.body)
                .foregroundColor(Color.primary)
            HStack(spacing: 8) {
                if let w = step.weight {
                    Text("\(w)g")
                        .font(.body)
                        .foregroundColor(Color("DeepGreen"))
                }
                if let t = step.time {
                    Text("\(t)s")
                        .font(.body)
                        .foregroundColor(Color("DeepGreen"))
                }
            }
        }
    }
}
