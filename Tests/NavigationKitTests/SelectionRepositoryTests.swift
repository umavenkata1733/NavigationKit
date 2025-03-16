//
//  SelectionRepositoryTests.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import XCTest
@testable import SelectionViewKit

final class SelectionRepositoryTests: XCTestCase {
    private var repository: SelectionRepository<MockSelectable>!
    private var items: [MockSelectable]!
    
    override func setUp() {
        super.setUp()
        items = [
            MockSelectable(displayText: "Item 1"),
            MockSelectable(displayText: "Item 2")
        ]
        repository = SelectionRepository(items: items)
    }
    
    func testInit() {
        XCTAssertEqual(repository.items.count, items.count)
        XCTAssertNil(repository.selectedItem)
    }
    
    func testInit_WithSelectedItem() {
        let selectedItem = items.first!
        repository = SelectionRepository(items: items, selectedItem: selectedItem)
        
        XCTAssertEqual(repository.selectedItem?.displayText, selectedItem.displayText)
    }
    
    func testSelect() {
        let item = items.first!
        repository.select(item)
        
        XCTAssertEqual(repository.selectedItem?.displayText, item.displayText)
    }
}
