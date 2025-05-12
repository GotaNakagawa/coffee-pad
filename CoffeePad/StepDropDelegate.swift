import SwiftUI

struct StepDropDelegate: DropDelegate {
    let item: BrewStepType
    @Binding var items: [BrewStepType]
    @Binding var draggedItem: BrewStepType?

    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let dragged = draggedItem,
              dragged != item,
              let fromIndex = items.firstIndex(of: dragged),
              let toIndex = items.firstIndex(of: item)
        else { return }

        // アニメーションしながら入れ替え
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
}
