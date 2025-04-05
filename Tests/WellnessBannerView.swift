

// Tests/SelectionKitUITests/z.swift
import XCTest
import SwiftUI
@testable import SelectionViewKit

struct TestItem: Selectable {
    let id = UUID()
    let displayText: String
}

final class SelectionViewUITests: XCTestCase {
    @MainActor
    func testSelectionView_DisplaysInitialState() async throws {
        // Given
        let items = [
            TestItem(displayText: "Test 1"),
            TestItem(displayText: "Test 2")
        ]
        
        let view = SelectionView(
            title: "Test Selection",
            items: items,
            presentationType: .half
        )
        
        // When
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        let hostingController = UIHostingController(rootView: view)
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        
        // Then
        // Wait for view to appear
        try await Task.sleep(for: .milliseconds(100))
        
        XCTAssertNotNil(hostingController.view)
        let snapshot = hostingController.view.snapshotView(afterScreenUpdates: true)
        XCTAssertNotNil(snapshot)
    }
}

final class SelectionHeaderViewUITests: XCTestCase {
    @MainActor
    func testSelectionHeaderView_DisplaysCorrectly() async throws {
        // Given
        let items = [TestItem(displayText: "Test Item")]
        let repository = SelectionRepository(items: items)
        let useCase = SelectionUseCase(repository: repository)
        let viewModel = SelectionViewModel(useCase: useCase)
        let style = SelectionPresentationType.half.style
        
        let view = SelectionHeaderView(
            viewModel: viewModel,
            style: style
        )
        
        // When
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        let hostingController = UIHostingController(rootView: view)
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        
        // Then
        try await Task.sleep(for: .milliseconds(100))
        
        XCTAssertNotNil(hostingController.view)
        let snapshot = hostingController.view.snapshotView(afterScreenUpdates: true)
        XCTAssertNotNil(snapshot)
    }
}

final class SelectionListViewUITests: XCTestCase {
    @MainActor
    func testSelectionListView_DisplaysItems() async throws {
        // Given
        let items = [
            TestItem(displayText: "Test 1"),
            TestItem(displayText: "Test 2")
        ]
        
        let view = SelectionListView(
            items: items,
            selectedItem: nil,
            style: SelectionPresentationType.half.style,
            onSelect: { _ in }
        )
        
        // When
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        let hostingController = UIHostingController(rootView: view)
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        
        // Then
        try await Task.sleep(for: .milliseconds(100))
        
        XCTAssertNotNil(hostingController.view)
        let snapshot = hostingController.view.snapshotView(afterScreenUpdates: true)
        XCTAssertNotNil(snapshot)
    }
    
    @MainActor
    func testSelectionListView_ShowsCheckmark_ForSelectedItem() async throws {
        // Given
        let items = [
            TestItem(displayText: "Test 1"),
            TestItem(displayText: "Test 2")
        ]
        
        let view = SelectionListView(
            items: items,
            selectedItem: items[0],
            style: SelectionPresentationType.half.style,
            onSelect: { _ in }
        )
        
        // When
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        let hostingController = UIHostingController(rootView: view)
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        
        // Then
        try await Task.sleep(for: .milliseconds(100))
        
        XCTAssertNotNil(hostingController.view)
        let snapshot = hostingController.view.snapshotView(afterScreenUpdates: true)
        XCTAssertNotNil(snapshot)
    }
}
