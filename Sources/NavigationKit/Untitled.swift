import XCTest
@testable import DropdownMenu // Replace with your module name

final class DropdownDelegateTests: XCTestCase {

    final class MockDelegate: DropdownDelegate {
        var didSelectOptionCalled = false
        var didDismissCalled = false
        var selectedValue: String?

        func didSelectOption<T>(_ option: T) {
            didSelectOptionCalled = true
            selectedValue = option as? String
        }

        func didDismiss() {
            didDismissCalled = true
        }
    }

    func testDidSelectOption() {
        let mock = MockDelegate()
        let anyDelegate = AnyDropdownDelegate<String>(mock)

        anyDelegate.didSelectOption("Test Option")

        XCTAssertTrue(mock.didSelectOptionCalled)
        XCTAssertEqual(mock.selectedValue, "Test Option")
    }

    func testDidDismiss() {
        let mock = MockDelegate()
        let anyDelegate = AnyDropdownDelegate<String>(mock)

        anyDelegate.didDismiss()

        XCTAssertTrue(mock.didDismissCalled)
    }

    func testDidSelectOptionWithWrongType() {
        let mock = MockDelegate()
        let anyDelegate = AnyDropdownDelegate<String>(mock)

        anyDelegate.didSelectOption(123) // Int instead of String

        XCTAssertFalse(mock.didSelectOptionCalled)
        XCTAssertNil(mock.selectedValue)
    }
}
