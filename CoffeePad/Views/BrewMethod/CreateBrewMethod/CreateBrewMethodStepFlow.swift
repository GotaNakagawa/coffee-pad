import Inject
import SwiftUI

struct CreateBrewMethodStepFlow: View {
    @ObserveInjection var inject
    @Binding var steps: [String]
    @State private var showSheet = false
    @State private var draggedItem: String?

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("ドリップの流れを追加")
                    .font(.title)
                    .bold()
                CreateBrewMethodStepList(steps: self.$steps, draggedItem: self.$draggedItem)
            }
            .padding([.top, .leading, .trailing])
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
    @Binding var steps: [String]
    @Binding var draggedItem: String?

    var body: some View {
        if self.steps.isEmpty {
            Text("＋ボタンから手順を追加してください")
                .foregroundColor(.gray)
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(self.steps.indices, id: \.self) { index in
                        let step = self.steps[index]
                        HStack(spacing: 12) {
                            Image(systemName: "drop.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color("DeepGreen"))
                            Text(self.extractStepTitle(step))
                                .font(.body)
                                .foregroundColor(Color.primary)
                            Spacer()
                            Text(self.extractStepValues(step))
                                .font(.body)
                                .foregroundColor(Color("DeepGreen"))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("DarkBrown"), lineWidth: 3)
                        )
                        .cornerRadius(10)
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
                .padding(.trailing, 12)
            }
        }
    }

    private func extractStepTitle(_ step: String) -> String {
        if let range = step.range(of: "[0-9]+g|[0-9]+s", options: .regularExpression) {
            return String(step[..<range.lowerBound]).trimmingCharacters(in: .whitespaces)
        }
        return step
    }

    private func extractStepValues(_ step: String) -> String {
        let regex = try? NSRegularExpression(pattern: "[0-9]+g|[0-9]+s")
        let matches = regex?.matches(in: step, range: NSRange(step.startIndex..., in: step)) ?? []
        let values = matches.compactMap { match -> String? in
            if let range = Range(match.range, in: step) {
                return String(step[range])
            }
            return nil
        }
        return values.joined(separator: " ")
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

private struct CreateBrewMethodStepAddButton: View {
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
