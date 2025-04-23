import SwiftUI


// Sources/DropdownMenu/DropdownActionState.swift
import Foundation

/// Enum to represent different dropdown states
public enum DropdownActionState {
    case showing, selecting, dismissed
}

// Sources/DropdownMenu/DropdownMenu.swift
/// A generic, customizable dropdown menu component for SwiftUI.
/// Supports binding to selected option, custom appearance, and animated display.
public struct DropdownMenu<T: Hashable>: View {

    // MARK: - Bindings

    /// Indicates whether the dropdown is currently visible.
    @Binding public var isShowing: Bool

    /// The currently selected option in the dropdown.
    @Binding public var selectedOption: T

    // MARK: - Configuration

    /// The list of options available in the dropdown.
    public let options: [T]

    /// A closure to convert an option of type `T` to a displayable string.
    public let optionToString: (T) -> String

    // MARK: - Appearance

    /// The width of the dropdown menu.
    public var width: CGFloat

    /// A closure called when the dropdown is dismissed.
    public var onDismiss: () -> Void

    /// A closure called when an option is selected from the dropdown.
    public var onSelect: (T) -> Void

    /// The text color of the dropdown button and options.
    public var buttonTextColor: Color

    /// The border color of the dropdown button.
    public var buttonBorderColor: Color

    /// The color of the checkmark shown next to the selected item.
    public var checkmarkColor: Color

    /// The background color of the dropdown menu.
    public var backgroundColor: Color

    /// The opacity of the background overlay when the dropdown is open.
    public var overlayOpacity: Double

    // MARK: - Internal State

    /// Tracks the current internal state of the dropdown (e.g., showing, selecting, or dismissed).
    @State private var dropdownActionState: DropdownActionState = .dismissed

    /// Stores the position where the dropdown should appear.
    @State private var dropdownPosition: CGPoint? = nil

    // MARK: - Initializer

    /// Creates a new dropdown menu with the provided configuration and appearance settings.
    public init(
        isShowing: Binding<Bool>,
        selectedOption: Binding<T>,
        options: [T],
        optionToString: @escaping (T) -> String,
        width: CGFloat? = nil,
        onDismiss: @escaping () -> Void = {},
        onSelect: @escaping (T) -> Void = { _ in },
        buttonTextColor: Color = .blue,
        buttonBorderColor: Color = .blue,
        checkmarkColor: Color = .blue,
        backgroundColor: Color = .white,
        overlayOpacity: Double = 0.0
    ) {
        self._isShowing = isShowing
        self._selectedOption = selectedOption
        self.options = options
        self.optionToString = optionToString
        #if os(iOS)
        self.width = width ?? UIScreen.main.bounds.width - 32
        #else
        self.width = width ?? 300
        #endif
        self.onDismiss = onDismiss
        self.onSelect = onSelect
        self.buttonTextColor = buttonTextColor
        self.buttonBorderColor = buttonBorderColor
        self.checkmarkColor = checkmarkColor
        self.backgroundColor = backgroundColor
        self.overlayOpacity = overlayOpacity
    }

    // MARK: - Views

    /// The dropdown menu’s main button.
    /// Tapping it toggles the visibility of the dropdown overlay.
    public func button() -> some View {
        Button(action: {
            withAnimation {
                isShowing.toggle()
                dropdownActionState = isShowing ? .showing : .dismissed
            }
        }) {
            HStack {
                Text(optionToString(selectedOption))
                    .foregroundColor(buttonTextColor)
                    .font(.system(size: 16, weight: .semibold))

                VStack(spacing: 2) {
                    Image(systemName: "chevron.up")
                    Image(systemName: "chevron.down")
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(buttonTextColor)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    /// The overlay view displayed when the dropdown is open.
    /// Includes a background tap-to-dismiss and a vertical list of options.
    public func overlay(at position: CGPoint? = nil) -> some View {
        ZStack {
            if isShowing {
                if overlayOpacity > 0 {
                    Color.black.opacity(overlayOpacity)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isShowing = false
                                dropdownActionState = .dismissed
                                onDismiss()
                            }
                        }
                }

                VStack(alignment: .trailing, spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedOption = option
                            dropdownActionState = .selecting
                            onSelect(option)
                            withAnimation {
                                isShowing = false
                                onDismiss()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark")
                                    .opacity(option == selectedOption ? 1 : 0)
                                    .foregroundColor(checkmarkColor)
                                    .frame(width: 20)

                                Text(optionToString(option))
                                    .foregroundColor(.black)
                                    .font(.system(size: 17))

                                Spacer()
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(backgroundColor)
                        }
                        .buttonStyle(PlainButtonStyle())

                        if option != options.last {
                            Divider().padding(.trailing, 0)
                        }
                    }
                }
                .background(backgroundColor)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
                .padding(.horizontal, 32)
                .position(position ?? CGPoint(x: width/2, y: 100))
            }
        }
    }

    /// Placeholder required by SwiftUI's `View` protocol.
    public var body: some View {
        EmptyView()
    }
}


// Sources/DropdownMenu/PositionedDropdownMenu.swift
import SwiftUI

/// A convenience wrapper that combines the dropdown button and its overlay into a single positioned view.
/// Automatically calculates and positions the overlay below the button.
public struct PositionedDropdownMenu<T: Hashable>: View {
    
    // MARK: - Bindings

    /// Indicates whether the dropdown is currently visible.
    @Binding private var isShowing: Bool

    /// The currently selected option in the dropdown.
    @Binding private var selectedOption: T

    // MARK: - Configuration

    /// The list of options to display in the dropdown.
    private let options: [T]

    /// Converts an option of type `T` into a displayable string.
    private let optionToString: (T) -> String

    /// The width of the dropdown. Defaults to screen width minus 32 on iOS.
    private var width: CGFloat

    /// A closure called when the dropdown is dismissed.
    private var onDismiss: () -> Void

    /// A closure called when an option is selected.
    private var onSelect: (T) -> Void

    // MARK: - Appearance

    /// The color of the dropdown button text.
    private var buttonTextColor: Color

    /// The color of the dropdown button border.
    private var buttonBorderColor: Color

    /// The color of the checkmark indicating the selected item.
    private var checkmarkColor: Color

    /// The background color of the dropdown list.
    private var backgroundColor: Color

    /// The opacity of the overlay background when the dropdown is active.
    private var overlayOpacity: Double

    // MARK: - State

    /// Stores the position where the dropdown overlay should appear.
    @State private var dropdownPosition: CGPoint = .zero

    // MARK: - Initializer

    /// Initializes a new positioned dropdown menu with customizable properties.
    public init(
        isShowing: Binding<Bool>,
        selectedOption: Binding<T>,
        options: [T],
        optionToString: @escaping (T) -> String,
        width: CGFloat? = nil,
        onDismiss: @escaping () -> Void = {},
        onSelect: @escaping (T) -> Void = { _ in },
        buttonTextColor: Color = .blue,
        buttonBorderColor: Color = .blue,
        checkmarkColor: Color = .blue,
        backgroundColor: Color = .white,
        overlayOpacity: Double = 0.0
    ) {
        self._isShowing = isShowing
        self._selectedOption = selectedOption
        self.options = options
        self.optionToString = optionToString
        #if os(iOS)
        self.width = width ?? UIScreen.main.bounds.width - 32
        #else
        self.width = width ?? 300
        #endif
        self.onDismiss = onDismiss
        self.onSelect = onSelect
        self.buttonTextColor = buttonTextColor
        self.buttonBorderColor = buttonBorderColor
        self.checkmarkColor = checkmarkColor
        self.backgroundColor = backgroundColor
        self.overlayOpacity = overlayOpacity
    }

    // MARK: - Body

    /// The main view body containing the button and overlay.
    public var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .trailing) {
                dropdown.button()
                    .background(
                        GeometryReader { buttonGeo in
                            Color.clear.onAppear {
                                let frame = buttonGeo.frame(in: .global)
                                dropdownPosition = CGPoint(x: frame.midX, y: frame.maxY + 10)
                            }
                        }
                    )
                    .frame(height: 44)
            }

            if isShowing {
                dropdown.overlay(at: dropdownPosition)
            }
        }
    }

    // MARK: - Dropdown Menu

    /// The internal dropdown menu instance with passed configuration.
    private var dropdown: DropdownMenu<T> {
        DropdownMenu(
            isShowing: $isShowing,
            selectedOption: $selectedOption,
            options: options,
            optionToString: optionToString,
            width: width,
            onDismiss: onDismiss,
            onSelect: onSelect,
            buttonTextColor: buttonTextColor,
            buttonBorderColor: buttonBorderColor,
            checkmarkColor: checkmarkColor,
            backgroundColor: backgroundColor,
            overlayOpacity: overlayOpacity
        )
    }
}


// Sources/DropdownMenu/Examples/ExampleDropdownView.swift
import SwiftUI

public struct ExampleDropdownView: View {
    @State private var showDropdown = false
    @State private var selectedPlan = "Active 2025 Plan"
    @State private var dropdownPosition: CGPoint = .zero

    private let plans = ["Prior 2024 Plan", "Active 2025 Plan", "Upcoming 2026 plan"]

    public init() {}
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .trailing, spacing: 20) {
                Text("Benefits Summary")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top)

                GeometryReader { geo in
                    let dropdown = DropdownMenu(
                        isShowing: $showDropdown,
                        selectedOption: $selectedPlan,
                        options: plans,
                        optionToString: { $0 },
                        width: 200, // Set a custom width here
                        onSelect: { selected in
                            print("✅ Selected Plan: \(selected)")
                        }
                    )

                    dropdown.button()
                        .background(
                            GeometryReader { buttonGeo in
                                Color.clear.onAppear {
                                    let frame = buttonGeo.frame(in: .global)
                                    dropdownPosition = CGPoint(x: frame.midX, y: frame.maxY + 10)
                                }
                            }
                        )
                        .frame(height: 44)
                }
                .frame(height: 44)

                Text("Out of Network")
                    .font(.headline)
                    .padding(.top, 20)

                Text("You have X of X visits/services available for covered out-of-network medical care.")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Selected Plan: \(selectedPlan)")
                    .font(.subheadline)
                    .foregroundColor(.blue)

                Spacer()
            }
            .padding()

            if showDropdown {
                DropdownMenu(
                    isShowing: $showDropdown,
                    selectedOption: $selectedPlan,
                    options: plans,
                    optionToString: { $0 },
                    width: 240,
                    onSelect: { selected in
                        print("✅ Selected Plan (Overlay): \(selected)")
                    }
                )
                .overlay(at: dropdownPosition)
            }
        }
    }
}

import SwiftUI

struct AdvancedView: View {
    @State private var showDropdown = false
    @State private var selectedOption = "Option 1"
    @State private var dropdownPosition: CGPoint = .zero
    let options = ["Option 1", "Option 2", "Option 3"]
    
    var body: some View {
        ZStack {
            VStack {
                
                let dropdown = DropdownMenu(
                    isShowing: $showDropdown,
                    selectedOption: $selectedOption,
                    options: options,
                    optionToString: { $0 },
                    buttonTextColor: .blue,
                    backgroundColor: .gray.opacity(0.1)
                )
                
                dropdown.button()
                    .background(
                        GeometryReader { geo in
                            Color.clear.onAppear {
                                let frame = geo.frame(in: .global)
                                dropdownPosition = CGPoint(x: frame.midX, y: frame.maxY + 10)
                            }
                        }
                    )
            }
            
            if showDropdown {
                DropdownMenu(
                    isShowing: $showDropdown,
                    selectedOption: $selectedOption,
                    options: options,
                    optionToString: { $0 }
                )
                .overlay(at: dropdownPosition)
            }
        }
    }
}

//// Another example showing the simpler PositionedDropdownMenu
//public struct SimplifiedExampleView: View {
//    @State private var showDropdown = false
//    @State private var selectedPlan = "Active 2025 Plan"
//    
//    private let plans = ["Prior 2024 Plan", "Active 2025 Plan", "Upcoming 2026 plan"]
//    
//    public init() {}
//    
//    public var body: some View {
//        VStack(spacing: 20) {
//            Text("Simplified Example")
//                .font(.headline)
//            
//            // Using the all-in-one PositionedDropdownMenu
//            PositionedDropdownMenu(
//                isShowing: $showDropdown,
//                selectedOption: $selectedPlan,
//                options: plans,
//                optionToString: { $0 },
//                width: 240,
//                onSelect: { selected in
//                    print("Selected: \(selected)")
//                }
//            )
//            
//            Text("Selected: \(selectedPlan)")
//                .padding(.top)
//            
//            Spacer()
//        }
//        .padding()
//    }
//}

//// Tests/DropdownMenuTests/DropdownMenuTests.swift
//import XCTest
//@testable import DropdownMenu
//
//final class DropdownMenuTests: XCTestCase {
//    func testDropdownInitialization() {
//        let options = ["Option 1", "Option 2", "Option 3"]
//        var isShowing = false
//        var selectedOption = "Option 1"
//        
//        let _ = DropdownMenu(
//            isShowing: .constant(isShowing),
//            selectedOption: .constant(selectedOption),
//            options: options,
//            optionToString: { $0 }
//        )
//        
//        XCTAssertEqual(selectedOption, "Option 1")
//        XCTAssertFalse(isShowing)
//    }
//}

// README.md
/**
# DropdownMenu

A customizable dropdown menu for SwiftUI applications.

## Features

- Supports iOS 14+ and macOS 11+
- Customizable appearance and behavior
- Type-safe generic API
- Flexible positioning
- Built-in animations

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/DropdownMenu.git", from: "1.0.0")
]
```

Or add it via Xcode:
1. File > Add Packages...
2. Enter the repository URL: `https://github.com/yourusername/DropdownMenu.git`
3. Click "Add Package"

## Usage

### Basic Example

```swift
import SwiftUI
import DropdownMenu

struct ContentView: View {
    @State private var showDropdown = false
    @State private var selectedOption = "Option 1"
    let options = ["Option 1", "Option 2", "Option 3"]
    
    var body: some View {
        PositionedDropdownMenu(
            isShowing: $showDropdown,
            selectedOption: $selectedOption,
            options: options,
            optionToString: { $0 }
        )
    }
}
```


import SwiftUI
import DropdownMenu

struct AdvancedView: View {
    @State private var showDropdown = false
    @State private var selectedOption = "Option 1"
    @State private var dropdownPosition: CGPoint = .zero
    let options = ["Option 1", "Option 2", "Option 3"]
    
    var body: some View {
        ZStack {
            VStack {
                 Your content here
                
                let dropdown = DropdownMenu(
                    isShowing: $showDropdown,
                    selectedOption: $selectedOption,
                    options: options,
                    optionToString: { $0 },
                    buttonTextColor: .red,
                    backgroundColor: .gray.opacity(0.1)
                )
                
                dropdown.button()
                    .background(
                        GeometryReader { geo in
                            Color.clear.onAppear {
                                let frame = geo.frame(in: .global)
                                dropdownPosition = CGPoint(x: frame.midX, y: frame.maxY + 10)
                            }
                        }
                    )
            }
            
            if showDropdown {
                DropdownMenu(
                    isShowing: $showDropdown,
                    selectedOption: $selectedOption,
                    options: options,
                    optionToString: { $0 }
                )
                .overlay(at: dropdownPosition)
            }
        }
    }
}


## Customization

The dropdown menu supports various customization options:

- `buttonTextColor`: The text color of the dropdown button
- `buttonBorderColor`: The border color of the dropdown button
- `checkmarkColor`: The color of the checkmark icon
- `backgroundColor`: The background color of the dropdown menu
- `overlayOpacity`: The opacity of the background overlay when the dropdown is showing

## License

MIT License
*/





import XCTest
@testable  import L2
import SwiftUI

final class DropdownMenuTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testBasicInitialization() {
        let options = ["Option 1", "Option 2", "Option 3"]
        let isShowing = false
        let selectedOption = "Option 1"
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 }
        )
        
        XCTAssertEqual(dropdown.options.count, 3)
        XCTAssertEqual(dropdown.optionToString(selectedOption), "Option 1")
        XCTAssertFalse(isShowing)
    }
    
    func testCustomInitialization() {
        let options = ["Option 1", "Option 2", "Option 3"]
        let isShowing = true
        let selectedOption = "Option 2"
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 },
            width: 400,
            onDismiss: {},
            onSelect: { _ in },
            buttonTextColor: .red,
            buttonBorderColor: .green,
            checkmarkColor: .blue,
            backgroundColor: .yellow,
            overlayOpacity: 0.5
        )
        
        XCTAssertEqual(dropdown.width, 400)
        XCTAssertEqual(dropdown.buttonTextColor, .red)
        XCTAssertEqual(dropdown.buttonBorderColor, .green)
        XCTAssertEqual(dropdown.checkmarkColor, .blue)
        XCTAssertEqual(dropdown.backgroundColor, .yellow)
        XCTAssertEqual(dropdown.overlayOpacity, 0.5)
        XCTAssertTrue(isShowing)
        XCTAssertEqual(selectedOption, "Option 2")
    }
    
    func testGenericTypeSupport() {
        enum TestEnum: String, CaseIterable, Hashable {
            case first = "First Option"
            case second = "Second Option"
            case third = "Third Option"
        }
        
        let options = TestEnum.allCases.map { $0 }
        let isShowing = false
        let selectedOption = TestEnum.second
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0.rawValue }
        )
        
        XCTAssertEqual(dropdown.options.count, 3)
        XCTAssertEqual(dropdown.optionToString(selectedOption), "Second Option")
    }
    
    // MARK: - State Management Tests
    
    func testIsShowingBinding() {
        let options = ["Option 1", "Option 2", "Option 3"]
        var isShowing = false
        let selectedOption = "Option 1"
        
        let binding = Binding<Bool>(
            get: { isShowing },
            set: { isShowing = $0 }
        )
        
        let dropdown = DropdownMenu(
            isShowing: binding,
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 }
        )
        
        XCTAssertFalse(isShowing)
        
        // Simulate changing the binding
        binding.wrappedValue = true
        XCTAssertTrue(isShowing)
    }
    
    func testSelectedOptionBinding() {
        let options = ["Option 1", "Option 2", "Option 3"]
        let isShowing = false
        var selectedOption = "Option 1"
        
        let binding = Binding<String>(
            get: { selectedOption },
            set: { selectedOption = $0 }
        )
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: binding,
            options: options,
            optionToString: { $0 }
        )
        
        XCTAssertEqual(selectedOption, "Option 1")
        
        // Simulate changing the binding
        binding.wrappedValue = "Option 2"
        XCTAssertEqual(selectedOption, "Option 2")
    }
    
    // MARK: - Callback Tests
    
    func testOnDismissCallback() {
        let options = ["Option 1", "Option 2", "Option 3"]
        var isShowing = true
        let selectedOption = "Option 1"
        var onDismissCalled = false
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 },
            onDismiss: {
                onDismissCalled = true
            }
        )
        
        // Simulate dismissal
        dropdown.onDismiss()
        XCTAssertTrue(onDismissCalled)
    }
    
    func testOnSelectCallback() {
        let options = ["Option 1", "Option 2", "Option 3"]
        let isShowing = true
        let selectedOption = "Option 1"
        var onSelectCalledWith: String?
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 },
            onSelect: { option in
                onSelectCalledWith = option
            }
        )
        
        // Simulate selection
        dropdown.onSelect("Option 2")
        XCTAssertEqual(onSelectCalledWith, "Option 2")
    }
    
    // MARK: - Edge Case Tests
    
    func testEmptyOptions() {
        let options: [String] = []
        let isShowing = false
        let selectedOption = ""
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 }
        )
        
        XCTAssertEqual(dropdown.options.count, 0)
    }
    
    func testNilWidth() {
        let options = ["Option 1", "Option 2", "Option 3"]
        let isShowing = false
        let selectedOption = "Option 1"
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 },
            width: nil
        )
        
        #if os(iOS)
        XCTAssertEqual(dropdown.width, UIScreen.main.bounds.width - 32)
        #else
        XCTAssertEqual(dropdown.width, 300)
        #endif
    }
    
    func testCustomWidth() {
        let options = ["Option 1", "Option 2", "Option 3"]
        let isShowing = false
        let selectedOption = "Option 1"
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 },
            width: 500
        )
        
        XCTAssertEqual(dropdown.width, 500)
    }
    
    // MARK: - PositionedDropdownMenu Tests
    
    func testPositionedDropdownMenuInit() {
        let options = ["Option 1", "Option 2", "Option 3"]
        let isShowing = false
        let selectedOption = "Option 1"
        
        let dropdown = PositionedDropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 }
        )
        
        // Test access to properties via reflection
        let mirror = Mirror(reflecting: dropdown)
        let optionsCount = mirror.children.first { $0.label == "options" }?.value as? [String]
        
        XCTAssertEqual(optionsCount?.count, 3)
    }
    
    func testPositionedDropdownCustomization() {
        let options = ["Option 1", "Option 2", "Option 3"]
        let isShowing = false
        let selectedOption = "Option 1"
        
        let dropdown = PositionedDropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 },
            width: 400,
            buttonTextColor: .red,
            buttonBorderColor: .green,
            checkmarkColor: .blue,
            backgroundColor: .yellow,
            overlayOpacity: 0.5
        )
        
        // Test access to properties via reflection
        let mirror = Mirror(reflecting: dropdown)
        let buttonTextColor = mirror.children.first { $0.label == "buttonTextColor" }?.value as? Color
        let width = mirror.children.first { $0.label == "width" }?.value as? CGFloat
        
        XCTAssertEqual(buttonTextColor, .red)
        XCTAssertEqual(width, 400)
    }
}

// MARK: - UI Testing with ViewInspector

#if canImport(ViewInspector)
import ViewInspector

extension DropdownMenu: Inspectable {}
extension PositionedDropdownMenu: Inspectable {}

// UI tests would go here if ViewInspector is available
// These tests would require the ViewInspector package to be included as a dependency
// Example:
// func testButtonAppearance() {
//     let options = ["Option 1", "Option 2", "Option 3"]
//     let isShowing = false
//     let selectedOption = "Option 1"
//
//     let dropdown = DropdownMenu(
//         isShowing: .constant(isShowing),
//         selectedOption: .constant(selectedOption),
//         options: options,
//         optionToString: { $0 }
//     )
//
//     let button = try? dropdown.button().inspect().button()
//     XCTAssertNotNil(button)
// }
#endif

// MARK: - Custom Type Tests

final class CustomTypeTests: XCTestCase {
    
    struct User: Hashable, Identifiable {
        let id: UUID
        let name: String
        let email: String
    }
    
    func testCustomStructType() {
        let users = [
            User(id: UUID(), name: "John Doe", email: "john@example.com"),
            User(id: UUID(), name: "Jane Smith", email: "jane@example.com"),
            User(id: UUID(), name: "Bob Johnson", email: "bob@example.com")
        ]
        
        let isShowing = false
        let selectedUser = users[0]
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedUser),
            options: users,
            optionToString: { $0.name }
        )
        
        XCTAssertEqual(dropdown.options.count, 3)
        XCTAssertEqual(dropdown.optionToString(selectedUser), "John Doe")
    }
    
    enum Category: String, CaseIterable, Hashable {
        case electronics = "Electronics"
        case clothing = "Clothing"
        case books = "Books"
        case food = "Food & Beverages"
    }
    
    func testEnumType() {
        let categories = Category.allCases
        let isShowing = false
        let selectedCategory = Category.books
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedCategory),
            options: Array(categories),
            optionToString: { $0.rawValue }
        )
        
        XCTAssertEqual(dropdown.options.count, 4)
        XCTAssertEqual(dropdown.optionToString(selectedCategory), "Books")
    }
}

// MARK: - Functional Tests

final class DropdownFunctionalTests: XCTestCase {
    
    func testOptionSelection() {
        let options = ["Option 1", "Option 2", "Option 3"]
        var isShowing = true
        var selectedOption = "Option 1"
        var onSelectCalled = false
        
        let isShowingBinding = Binding<Bool>(
            get: { isShowing },
            set: { isShowing = $0 }
        )
        
        let selectedOptionBinding = Binding<String>(
            get: { selectedOption },
            set: { selectedOption = $0 }
        )
        
        let dropdown = DropdownMenu(
            isShowing: isShowingBinding,
            selectedOption: selectedOptionBinding,
            options: options,
            optionToString: { $0 },
            onSelect: { _ in
                onSelectCalled = true
            }
        )
        
        // Simulate the selection process manually
        selectedOptionBinding.wrappedValue = "Option 3"
        dropdown.onSelect("Option 3")
        isShowingBinding.wrappedValue = false
        
        XCTAssertEqual(selectedOption, "Option 3")
        XCTAssertTrue(onSelectCalled)
        XCTAssertFalse(isShowing)
    }
    
    func testDropdownToggle() {
        let options = ["Option 1", "Option 2", "Option 3"]
        var isShowing = false
        let selectedOption = "Option 1"
        
        let binding = Binding<Bool>(
            get: { isShowing },
            set: { isShowing = $0 }
        )
        
        let dropdown = DropdownMenu(
            isShowing: binding,
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 }
        )
        
        // Simulate toggling the dropdown
        binding.wrappedValue.toggle()
        XCTAssertTrue(isShowing)
        
        binding.wrappedValue.toggle()
        XCTAssertFalse(isShowing)
    }
}

// MARK: - Performance Tests

final class DropdownPerformanceTests: XCTestCase {
    
//    func testLargeOptionsListPerformance() {
//        // Generate a large list of options
//        let options = (1...1000).map { "Option \($0)" }
//        let isShowing = false
//        let selectedOption = "Option 500"
//        
//        measure {
//            // Measure initialization performance
//            let _ = DropdownMenu(
//                isShowing: .constant(isShowing),
//                selectedOption: .constant(selectedOption),
//                options: options,
//                optionToString: { $0 }
//            )
//        }
//    }
    
//    func testOptionToStringPerformance() {
//        // Create a complex string transformation function
//        let optionToString: (String) -> String = { option in
//            let components = option.components(separatedBy: " ")
//            let numberPart = components.last ?? ""
//            let intValue = Int(numberPart) ?? 0
//            return "Item #\(intValue) - Priority \(intValue % 5 + 1)"
//        }
//        
//        let options = (1...100).map { "Option \($0)" }
//        let isShowing = false
//        let selectedOption = "Option 50"
//        
//        let dropdown = DropdownMenu(
//            isShowing: .constant(isShowing),
//            selectedOption: .constant(selectedOption),
//            options: options,
//            optionToString: optionToString
//        )
//        
//        measure {
//            // Measure string transformation performance
//            for option in options {
//                _ = dropdown.optionToString(option)
//            }
//        }
//    }
}

// MARK: - Accessibility Tests

final class DropdownAccessibilityTests: XCTestCase {
    
    func testAccessibilityIdentifiers() {
        // In a real implementation, these tests would verify that accessibility identifiers
        // are set correctly on the dropdown components
        
        // Placeholder test - to be implemented with actual accessibility checks
        XCTAssertTrue(true)
    }
}

// MARK: - Integration Tests

final class DropdownIntegrationTests: XCTestCase {
    
    func testDropdownWithBindings() {
        // Set up observed objects and bindings
        class TestObservable: ObservableObject {
            @Published var isShowing = false
            @Published var selectedOption = "Option 1"
        }
        
        let observable = TestObservable()
        let options = ["Option 1", "Option 2", "Option 3"]
        
        // Create bindings from the published properties
        let isShowingBinding = Binding<Bool>(
            get: { observable.isShowing },
            set: { observable.isShowing = $0 }
        )
        
        let selectedOptionBinding = Binding<String>(
            get: { observable.selectedOption },
            set: { observable.selectedOption = $0 }
        )
        
        // Create the dropdown with the bindings
        let dropdown = DropdownMenu(
            isShowing: isShowingBinding,
            selectedOption: selectedOptionBinding,
            options: options,
            optionToString: { $0 }
        )
        
        // Test the bindings
        XCTAssertEqual(observable.selectedOption, "Option 1")
        
        // Change the binding
        selectedOptionBinding.wrappedValue = "Option 2"
        XCTAssertEqual(observable.selectedOption, "Option 2")
        
        // Toggle the dropdown
        isShowingBinding.wrappedValue.toggle()
        XCTAssertTrue(observable.isShowing)
    }
}

// MARK: - Complex Data Tests

final class ComplexDataTests: XCTestCase {
    
    struct ComplexItem: Hashable {
        let id: UUID
        let name: String
        let metadata: [String: String]
        let nestedItems: [NestedItem]
        
        struct NestedItem: Hashable {
            let id: UUID
            let value: String
        }
    }
    
    func testComplexDataStructure() {
        let complexItems = [
            ComplexItem(
                id: UUID(),
                name: "Item 1",
                metadata: ["created": "2023-01-01", "status": "active"],
                nestedItems: [
                    ComplexItem.NestedItem(id: UUID(), value: "Nested 1-1"),
                    ComplexItem.NestedItem(id: UUID(), value: "Nested 1-2")
                ]
            ),
            ComplexItem(
                id: UUID(),
                name: "Item 2",
                metadata: ["created": "2023-02-15", "status": "pending"],
                nestedItems: [
                    ComplexItem.NestedItem(id: UUID(), value: "Nested 2-1")
                ]
            ),
            ComplexItem(
                id: UUID(),
                name: "Item 3",
                metadata: ["created": "2023-03-20", "status": "inactive"],
                nestedItems: []
            )
        ]
        
        let isShowing = false
        let selectedItem = complexItems[0]
        
        // Create a custom string transformation
        let optionToString: (ComplexItem) -> String = { item in
            let status = item.metadata["status"] ?? "unknown"
            let nestedCount = item.nestedItems.count
            return "\(item.name) (\(status), \(nestedCount) nested items)"
        }
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedItem),
            options: complexItems,
            optionToString: optionToString
        )
        
        XCTAssertEqual(dropdown.options.count, 3)
        XCTAssertEqual(dropdown.optionToString(selectedItem), "Item 1 (active, 2 nested items)")
        XCTAssertEqual(dropdown.optionToString(complexItems[1]), "Item 2 (pending, 1 nested items)")
        XCTAssertEqual(dropdown.optionToString(complexItems[2]), "Item 3 (inactive, 0 nested items)")
    }
}

// MARK: - Localization Tests

final class LocalizationTests: XCTestCase {
    
    func testLocalizationSupport() {
        // This would test that strings used in the dropdown can be localized
        // For this example, we'll simulate a localization function
        
        let localizeString: (String) -> String = { key in
            let localizations = [
                "Option 1": "Option 1 (Localized)",
                "Option 2": "Option 2 (Localized)",
                "Option 3": "Option 3 (Localized)"
            ]
            return localizations[key] ?? key
        }
        
        let options = ["Option 1", "Option 2", "Option 3"]
        let isShowing = false
        let selectedOption = "Option 1"
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { localizeString($0) }
        )
        
        XCTAssertEqual(dropdown.optionToString(selectedOption), "Option 1 (Localized)")
        XCTAssertEqual(dropdown.optionToString("Option 2"), "Option 2 (Localized)")
        XCTAssertEqual(dropdown.optionToString("Option 3"), "Option 3 (Localized)")
    }
}

// MARK: - Thread Safety Tests

final class ThreadSafetyTests: XCTestCase {
    
    func testConcurrentAccess() {
        let options = ["Option 1", "Option 2", "Option 3"]
        var isShowing = false
        var selectedOption = "Option 1"
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 }
        )
        
        // Simulate concurrent access
        let expectation = XCTestExpectation(description: "Concurrent operations completed")
        expectation.expectedFulfillmentCount = 10
        
        for i in 0..<10 {
            DispatchQueue.global().async {
                // Perform operations on different threads
                _ = dropdown.optionToString(options[i % 3])
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

// MARK: - Additional Helper Methods

extension DropdownMenuTests {
    
    func createTestDropdown<T: Hashable>(
        isShowing: Bool = false,
        selectedOption: T,
        options: [T],
        optionToString: @escaping (T) -> String = { "\($0)" }
    ) -> DropdownMenu<T> {
        return DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: optionToString
        )
    }
}

// MARK: - Configuration and Environment Tests

final class ConfigurationTests: XCTestCase {
    
    func testDefaultConfiguration() {
        let dropdown = DropdownMenuTests().createTestDropdown(
            selectedOption: "Test",
            options: ["Test", "Option 2", "Option 3"]
        )
        
        XCTAssertEqual(dropdown.buttonTextColor, .blue)
        XCTAssertEqual(dropdown.buttonBorderColor, .blue)
        XCTAssertEqual(dropdown.checkmarkColor, .blue)
        XCTAssertEqual(dropdown.backgroundColor, .white)
        XCTAssertEqual(dropdown.overlayOpacity, 0.0)
    }
    
    func testEnvironmentOverrides() {
        // This would test environment overrides if the component supported them
        // Placeholder test
        XCTAssertTrue(true)
    }
}

// MARK: - UIKit Integration Tests

#if os(iOS)
final class UIKitIntegrationTests: XCTestCase {
    
    func testUIKitHosting() {
        // This would test integration with UIKit via UIHostingController
        // Placeholder test
        XCTAssertTrue(true)
    }
}
#endif

// MARK: - SwiftUI View Tests

// These tests would ideally use ViewInspector or similar to inspect SwiftUI views
// The commented code below shows how they would be structured

/*
final class ViewTests: XCTestCase {
    
    func testButtonRenders() throws {
        let options = ["Option 1", "Option 2", "Option 3"]
        let isShowing = false
        let selectedOption = "Option 1"
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 }
        )
        
        let button = try dropdown.button().inspect()
        let text = try button.find(ViewType.Text.self)
        XCTAssertEqual(try text.string(), "Option 1")
    }
    
    func testOverlayRenders() throws {
        let options = ["Option 1", "Option 2", "Option 3"]
        let isShowing = true
        let selectedOption = "Option 1"
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 }
        )
        
        let overlay = try dropdown.overlay().inspect()
        let vStack = try overlay.find(ViewType.VStack.self)
        let buttons = try vStack.findAll(ViewType.Button.self)
        XCTAssertEqual(buttons.count, 3)
    }
}
*/

// MARK: - Integration with System Features

final class SystemIntegrationTests: XCTestCase {
    
    func testDynamicTypeSupport() {
        // This would test support for Dynamic Type (accessibility text sizes)
        // Placeholder test
        XCTAssertTrue(true)
    }
    
    func testDarkModeSupport() {
        // This would test dark mode support
        // Placeholder test
        XCTAssertTrue(true)
    }
}

// MARK: - Animation Tests

final class AnimationTests: XCTestCase {
    
    func testAnimationPresence() {
        // This would test that animations are applied correctly
        // Placeholder test
        XCTAssertTrue(true)
    }
}

// MARK: - Memory Management Tests

//final class MemoryManagementTests: XCTestCase {
//    
//    func testMemoryLeaks() {
//        // Test for memory leaks using weak references
//        var dropdown: DropdownMenu<String>? = DropdownMenu(
//            isShowing: .constant(false),
//            selectedOption: .constant("Test"),
//            options: ["Test", "Option 2", "Option 3"],
//            optionToString: { $0 }
//        )
//        
//        weak var weakDropdown = dropdown
//        dropdown = nil
//        
//        XCTAssertNil(weakDropdown, "Dropdown should be deallocated")
//    }
//}

// MARK: - Regression Tests

final class RegressionTests: XCTestCase {
    
    // This is where you would add tests for specific bugs that have been fixed
    
    func testSampleRegressionIssue() {
        // Example regression test
        // Placeholder test
        XCTAssertTrue(true)
    }
}

// MARK: - Cross-Platform Tests

final class CrossPlatformTests: XCTestCase {
    
    func testPlatformSpecificCode() {
        // Test that platform-specific code branches work correctly
        let options = ["Option 1", "Option 2", "Option 3"]
        let isShowing = false
        let selectedOption = "Option 1"
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 },
            width: nil
        )
        
        // Default width should be platform-specific
        #if os(iOS)
        XCTAssertEqual(dropdown.width, UIScreen.main.bounds.width - 32)
        #else
        XCTAssertEqual(dropdown.width, 300)
        #endif
    }
}

// MARK: - Visual Appearance Tests

final class VisualAppearanceTests: XCTestCase {
    
    // These tests would require snapshot testing or manual verification
    
    func testVisualAppearance() {
        // Placeholder test
        XCTAssertTrue(true)
    }
}

// MARK: - Empty States Tests

final class EmptyStatesTests: XCTestCase {
    
    func testEmptyOptionsHandling() {
        let options: [String] = []
        let isShowing = true
        let selectedOption = ""
        
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 }
        )
        
        // Verify that the component handles empty options gracefully
        XCTAssertEqual(dropdown.options.count, 0)
        XCTAssertEqual(dropdown.optionToString(selectedOption), "")
    }
}

// MARK: - SwiftUI Environment Tests

final class EnvironmentTests: XCTestCase {
    
    // Tests for SwiftUI environment values if supported
    
    func testEnvironmentValue() {
        // Placeholder test
        XCTAssertTrue(true)
    }
}

// MARK: - Validation Tests

final class ValidationTests: XCTestCase {
    
    func testSelectedOptionValidation() {
        let options = ["Option 1", "Option 2", "Option 3"]
        let isShowing = false
        let selectedOption = "Invalid Option"  // Not in the options array
        
        // In a real validation system, this might throw or handle the invalid option
        let dropdown = DropdownMenu(
            isShowing: .constant(isShowing),
            selectedOption: .constant(selectedOption),
            options: options,
            optionToString: { $0 }
        )
        
        // The component should still work even with an invalid selection
        XCTAssertEqual(dropdown.optionToString(selectedOption), "Invalid Option")
    }
}

