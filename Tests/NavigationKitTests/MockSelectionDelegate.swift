//
//  MockSelectionDelegate.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

@testable import SelectionViewKit

final class MockSelectionDelegate: SelectionDelegate {
    typealias Item = MockSelectable
    private(set) var selectedItems: [MockSelectable?] = []
    
    func didSelect(item: MockSelectable?) {
        selectedItems.append(item)
    }
}
