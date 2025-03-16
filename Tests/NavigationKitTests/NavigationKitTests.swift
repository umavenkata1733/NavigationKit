import SwiftUI
import SelectionViewKit

struct ContentView: View {
    private let delegate = SelectionDelegateImpl()

    private let items = [
        ExampleItem(name: "Ramuvb Mahesh"),
        ExampleItem(name: "Team Alpha"),
        ExampleItem(name: "Division Beta")
    ]
    var body: some View {
        VStack {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // Full screen example
                        SelectionView(
                            title: "Full Screen Demo",
                            items: items,
                            presentationType: .full,
                            delegate: delegate
                        )
                        
                    }
                }
            }
        }
        .padding()
    }
}
struct ExampleItem: Selectable {
    let id = UUID()
    let name: String
    var displayText: String { name }
}

// Demo/Domain/Delegates/SelectionDelegateImpl.swift

final class SelectionDelegateImpl: SelectionDelegate {
    typealias Item = ExampleItem
    
    func didSelect(item: ExampleItem?) {
        if let item = item {
            print("Selected: \(item.name)")
        }
    }
}

