//
//  SelectionViewModelTests.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import XCTest
@testable import SelectionViewKit

@MainActor
final class SelectionViewModelTests: XCTestCase {
    private var repository: MockSelectionRepository!
    private var delegate: MockSelectionDelegate!
    private var useCase: SelectionUseCase<MockSelectable>!
    private var viewModel: SelectionViewModel<MockSelectable>!
    private var items: [MockSelectable]!
    
    override func setUp() async throws {
        items = [
            MockSelectable(displayText: "Item 1"),
            MockSelectable(displayText: "Item 2")
        ]
        repository = MockSelectionRepository(items: items)
        delegate = MockSelectionDelegate()
        useCase = SelectionUseCase(repository: repository, delegate: delegate)
        viewModel = SelectionViewModel(useCase: useCase)
    }
    
    func testInit() {
        XCTAssertNil(viewModel.selectedItem)
        XCTAssertEqual(
            viewModel.displayString,
            items.map { $0.displayText }.joined(separator: SelectionConstants.Strings.separator)
        )
    }
    
    func testGetItems() {
        let result = viewModel.getItems()
        XCTAssertEqual(result.count, items.count)
    }
    
    func testSelect() {
        let item = items.first!
        viewModel.select(item)
        
        XCTAssertEqual(viewModel.selectedItem?.displayText, item.displayText)
        XCTAssertEqual(viewModel.displayString, item.displayText)
        XCTAssertEqual(delegate.selectedItems.last??.displayText, item.displayText)
    }
}
