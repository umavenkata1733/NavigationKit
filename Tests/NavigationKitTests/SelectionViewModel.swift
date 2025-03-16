//
//  SelectionViewModel.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import SwiftUI

@MainActor
final class SelectionViewModel<Item: Selectable>: ObservableObject {
    @Published private(set) var selectedItem: Item?
    @Published private(set) var displayString: String = ""
    private let useCase: any SelectionUseCaseProtocol<Item>
    
    init(useCase: any SelectionUseCaseProtocol<Item>) {
        self.useCase = useCase
        self.selectedItem = useCase.getSelectedItem()
        updateDisplayString()
    }
    
    func getItems() -> [Item] {
        useCase.getItems()
    }
    
    func select(_ item: Item?) {
        useCase.setSelectedItem(item)
        selectedItem = item
        updateDisplayString()
    }
    
    private func updateDisplayString() {
        displayString = useCase.getDisplayString()
    }
}
