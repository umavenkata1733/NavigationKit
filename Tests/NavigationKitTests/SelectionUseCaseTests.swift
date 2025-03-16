//
//  SelectionUseCaseTests.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import XCTest
@testable import SelectionViewKit

final class SelectionUseCaseTests: XCTestCase {
    private var repository: MockSelectionRepository!
    private var delegate: MockSelectionDelegate!
    private var useCase: SelectionUseCase<MockSelectable>!
    private var items: [MockSelectable]!
    
    override func setUp() {
        super.setUp()
        items = [
            MockSelectable(displayText: "Item 1"),
            MockSelectable(displayText: "Item 2")
        ]
        repository = MockSelectionRepository(items: items)
        delegate = MockSelectionDelegate()
        useCase = SelectionUseCase(repository: repository, delegate: delegate)
    }
    
    func testGetItems() {
        let result = useCase.getItems()
        XCTAssertEqual(result.count, items.count)
        XCTAssertEqual(result.first?.displayText, items.first?.displayText)
    }
    
    func testGetSelectedItem_WhenNoneSelected() {
        XCTAssertNil(useCase.getSelectedItem())
    }
    
    func testSetSelectedItem() {
        let item = items.first!
        useCase.setSelectedItem(item)
        
        XCTAssertTrue(repository.selectCalled)
        XCTAssertEqual(repository.selectedItem?.displayText, item.displayText)
        XCTAssertEqual(delegate.selectedItems.last??.displayText, item.displayText)
    }
    
    func testGetDisplayString_WhenNoneSelected() {
        let expected = items.map { $0.displayText }.joined(separator: SelectionConstants.Strings.separator)
        XCTAssertEqual(useCase.getDisplayString(), expected)
    }
    
    func testGetDisplayString_WhenItemSelected() {
        let item = items.first!
        repository.selectedItem = item
        XCTAssertEqual(useCase.getDisplayString(), item.displayText)
    }
}
