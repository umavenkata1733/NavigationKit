//
//  SelectionRepository.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import SwiftUI

public final class SelectionRepository<Item: Selectable>: SelectionRepositoryProtocol {
    public private(set) var items: [Item]
    public var selectedItem: Item?
    
    public init(items: [Item], selectedItem: Item? = nil) {
        self.items = items
        self.selectedItem = selectedItem
    }
    
    public func select(_ item: Item?) {
        selectedItem = item
    }
}
