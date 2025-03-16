//
//  MockSelectionRepository.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

@testable import SelectionViewKit

final class MockSelectionRepository: SelectionRepositoryProtocol {
    typealias Item = MockSelectable
    private(set) var selectCalled = false
    
    var items: [MockSelectable]
    var selectedItem: MockSelectable?
    
    init(items: [MockSelectable], selectedItem: MockSelectable? = nil) {
        self.items = items
        self.selectedItem = selectedItem
    }
    
    func select(_ item: MockSelectable?) {
        selectCalled = true
        selectedItem = item
    }
}
