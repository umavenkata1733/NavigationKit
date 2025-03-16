//
//  SelectionUseCase.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import SwiftUI

public final class SelectionUseCase<Item: Selectable>: SelectionUseCaseProtocol {
    private let repository: any SelectionRepositoryProtocol<Item>
    private weak var delegate: (any SelectionDelegate<Item>)?
    
    public init(repository: any SelectionRepositoryProtocol<Item>,
                delegate: (any SelectionDelegate<Item>)? = nil) {
        self.repository = repository
        self.delegate = delegate
    }
    
    public func getItems() -> [Item] {
        repository.items
    }
    
    public func getSelectedItem() -> Item? {
        repository.selectedItem
    }
    
    public func setSelectedItem(_ item: Item?) {
        repository.select(item)
        delegate?.didSelect(item: item)
    }
    
    public func getDisplayString() -> String {
        if let selected = repository.selectedItem {
            return selected.displayText
        } else {
            return repository.items
                .map { $0.displayText }.first!
        }
    }
}
