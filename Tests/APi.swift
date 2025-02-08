//
//  Hello.swift
//  Temp
//
//  Created by Anand on 2/7/25.
//

import SwiftUI


/// A struct to define the selection style, including colors for different parts of a selection.
struct SelectionStyle {
    
    /// The background color of the icon.
    let iconBackground: Color
    
    /// The foreground color of the icon.
    let iconForeground: Color
    
    /// The color of the checkmark.
    let checkmark: Color
}

/// An enum to define different presentation types of the selection sheet.
public enum SelectionPresentationType {
    /// A half-size sheet.
    case half
    
    /// A full-size sheet.
    case full
    
    /// The detents (height options) for the sheet depending on the selected presentation type.
    var detents: Set<PresentationDetent> {
        switch self {
        case .half:
            // The sheet will have a medium size when the `.half` type is selected.
            return [.medium]
        case .full:
            // The sheet will have a large size when the `.full` type is selected.
            return [.large]
        }
    }
    
    /// The style to be applied based on the selected presentation type.
    var style: SelectionStyle {
        switch self {
        case .half:
            // Style for the half-size sheet with specific color settings.
            return SelectionStyle(
                iconBackground: .blue.opacity(0.1),
                iconForeground: .blue,
                checkmark: .blue
            )
        case .full:
            // Style for the full-size sheet with specific color settings.
            return SelectionStyle(
                iconBackground: .blue.opacity(0.1),
                iconForeground: .blue,
                checkmark: .blue
            )
        }
    }
}

/// A collection of constants used across the selection feature, including system images, strings, colors, and layout properties.
public enum SelectionConstants {
    
    /// System image icons used throughout the selection feature.
    public enum SystemImages {
        static let personicon = "person.2.fill"  // The icon for a person (2 people).
        static let chevronDown = "chevron.down"   // The down chevron icon.
        static let checkmark = "checkmark"        // The checkmark icon.
    }
    
    /// String constants used in the selection feature.
    public enum Strings {
        static let viewingInfoTitle = "Viewing information for:"  // Title shown when viewing information for a selection.
        static let separator = " / "                               // Separator between different elements.
        static let closeButton = "Close"                           // Label for the close button.
    }
    
    /// Colors for various parts of the selection feature.
    public enum StringsColors {
        static let systemBlueColor = "#3890BC"  // A hex color string representing the system blue color.
    }
    
    /// Layout-related constants, such as sizes and padding.
    public enum Layout {
        static let iconSize: CGFloat = 32          // The size of icons.
        static let iconFontSize: CGFloat = 14      // The font size for icons.
        static let titleFontSize: CGFloat = 16     // The font size for titles.
        static let contentFontSize: CGFloat = 18   // The font size for content.
        static let listContentFontSize: CGFloat = 16 // Font size for list items.
        static let spacing: CGFloat = 14           // Spacing between elements.
        static let cornerRadius: CGFloat = 20      // Corner radius for elements.
        static let padding: CGFloat = 16          // Padding around elements.
        static let titleHeaderFontSize: CGFloat = 12 // Font size for header titles.
    }
    
    /// Common colors used across the app.
    public enum Colors {
        static let titleColor = Color(.black)                // Color for titles (black).
        static let chevronColor = Color(.systemGray3)        // Color for chevrons (light gray).
        static let shadowColor = Color.black.opacity(0.05)   // A light shadow color.
    }
    
    /// App-specific images (icons) used throughout the app.
    public enum AppImage: String {
        case proxyImageIcon = "proxy_icon"  // Image representing a proxy icon.
    }
}

/// A protocol that defines a benefits proxy model.
/// Any type conforming to this protocol must provide a unique identifier.
public protocol BenefitsProxyProtocol {
    /// A unique identifier for the proxy.
    var proxyId: String { get }
    var proxyName: String { get }
}

/// A protocol that defines the use case for handling item selection.
/// It provides methods to retrieve items, get and set the selected item, and display a string representation of the selected item.
public protocol SelectionUseCaseProtocol<Item> {
    /// The type of item that conforms to `BenefitsProxyProtocol`.
    associatedtype Item: BenefitsProxyProtocol
    
    /// Retrieves the list of selectable items.
    func getItems() -> [Item]
    
    /// Retrieves the currently selected item.
    func getSelectedItem() -> Item?
    
    /// Retrieves a formatted display string for the selected item.
    func getDisplayString() -> String
    
    /// Sets the selected item.
    /// - Parameter item: The item to set as selected. Can be `nil` if no selection is made.
    func setSelectedItem(_ item: Item?)
}

/// A view model responsible for managing the selection state and business logic.
/// This class is an `ObservableObject` and ensures UI updates when selection changes.
@MainActor
final class SelectionViewModel<Item: BenefitsProxyProtocol>: ObservableObject {
    
    /// The currently selected item. Published to notify views of updates.
    @Published private(set) var selectedItem: Item?
    
    /// A display string representing the selected item. Published to notify views of updates.
    @Published private(set) var displayString: String = ""
    
    /// The use case responsible for handling selection logic.
    private let useCase: any SelectionUseCaseProtocol<Item>
    
    /// Initializes the view model with a given use case.
    /// - Parameter useCase: The use case that manages selection data and logic.
    init(useCase: any SelectionUseCaseProtocol<Item>) {
        self.useCase = useCase
        self.selectedItem = useCase.getSelectedItem()
        updateDisplayString()
    }
    
    /// Retrieves the list of selectable items from the use case.
    /// - Returns: An array of `Item` objects available for selection.
    func getItems() -> [Item] {
        useCase.getItems()
    }
    
    /// Selects an item and updates the selection state.
    /// - Parameter item: The item to be selected. Can be `nil` to clear the selection.
    func select(_ item: Item?) {
        useCase.setSelectedItem(item) // Update the selected item in the use case.
        selectedItem = item           // Update the view model’s selected item.
        updateDisplayString()         // Refresh the display string.
    }
    
    /// Updates the display string based on the currently selected item.
    private func updateDisplayString() {
        displayString = useCase.getDisplayString()
    }
}

/// A protocol defining the repository for managing selection data.
/// It provides access to a collection of selectable items and tracks the selected item.
public protocol SelectionRepositoryProtocol<Item> {
    /// The type of items conforming to `BenefitsProxyProtocol`.
    associatedtype Item: BenefitsProxyProtocol
    
    /// The collection of selectable items.
    var items: [Item] { get }
    
    /// The currently selected item, if any.
    var selectedItem: Item? { get set }
    
    /// Selects an item and updates the selection state.
    /// - Parameter item: The item to be selected.
    func select(_ item: Item?)
}

/// A protocol defining a delegate to handle selection events.
public protocol SelectionDelegate {
    /// Notifies when an item has been selected.
    /// - Parameter item: The selected item, conforming to `BenefitsProxyProtocol`. Can be `nil`.
    func didSelect(item: BenefitsProxyProtocol?)
}

/// A use case responsible for handling the selection logic.
/// This class interacts with a repository and notifies a delegate when a selection is made.
public final class SelectionUseCase<Item: BenefitsProxyProtocol>: SelectionUseCaseProtocol {
    
    /// The repository managing selection data.
    private let repository: any SelectionRepositoryProtocol<Item>
    
    /// An optional delegate that responds to selection events.
    private var delegate: SelectionDelegate?
    
    /// Initializes the use case with a repository and an optional delegate.
    /// - Parameters:
    ///   - repository: The repository that provides selection data.
    ///   - delegate: An optional delegate to handle selection events.
    public init(repository: any SelectionRepositoryProtocol<Item>, delegate: SelectionDelegate? = nil) {
        self.repository = repository
        self.delegate = delegate
    }
    
    /// Retrieves the list of selectable items.
    /// - Returns: An array of `Item` objects.
    public func getItems() -> [Item] {
        repository.items
    }
    
    /// Retrieves the currently selected item.
    /// - Returns: The selected `Item`, or `nil` if no item is selected.
    public func getSelectedItem() -> Item? {
        repository.selectedItem
    }
    
    /// Sets the selected item, updates the repository, and notifies the delegate.
    /// - Parameter item: The item to be selected.
    public func setSelectedItem(_ item: Item?) {
        repository.select(item) // Updates the repository's selected item.
        delegate?.didSelect(item: item) // Notifies the delegate about the selection.
    }
    
    /// Retrieves a display string representing the selected item.
    /// - Returns: The name of the selected item, or a default string if no selection is made.
    public func getDisplayString() -> String {
        if let selected = repository.selectedItem {
            return selected.proxyName
        } else {
            // Returns the name of the first item if available, otherwise a default prompt.
            return repository.items.map({ $0.proxyName }).first ?? "Select Proxy Group"
        }
    }
}


/// A repository that manages the selection of items conforming to `BenefitsProxyProtocol`.
/// It stores a list of items and tracks the currently selected item.
public final class SelectionRepository<Item: BenefitsProxyProtocol>: SelectionRepositoryProtocol {
    
    /// The list of selectable items. This property is read-only externally.
    public private(set) var items: [Item]
    
    /// The currently selected item, if any.
    public var selectedItem: Item?
    
    /// Initializes the repository with a collection of items and an optional pre-selected item.
    /// - Parameters:
    ///   - items: The list of available items.
    ///   - selectedItem: The initially selected item, if applicable. Defaults to `nil`.
    public init(items: [Item], selectedItem: Item? = nil) {
        self.items = items
        self.selectedItem = selectedItem
    }
    
    /// Updates the selected item.
    /// - Parameter item: The item to be selected.
    public func select(_ item: Item?) {
        selectedItem = item
    }
}

/// A view representing the header section for a selection interface.
/// This view displays information about the currently selected item.
struct SelectionHeaderView<Item: BenefitsProxyProtocol>: View {
    
    /// The view model that provides data for the selection view.
    @ObservedObject var viewModel: SelectionViewModel<Item>
    
    /// The style configuration for the selection header.
    let style: SelectionStyle
    
    /// The body of the view, defining its UI structure.
    var body: some View {
        VStack(alignment: .leading) {
            /// Displays a title text, informing the user about the viewing context.
            Text(SelectionConstants.Strings.viewingInfoTitle)
              
            Text(viewModel.displayString)
        }
    }
}

/// A view displaying a list of selectable items, allowing users to choose one.
/// When an item is selected, the view dismisses itself.
struct SelectionListView<Item: BenefitsProxyProtocol>: View {
    
    /// The list of items available for selection.
    let item: [Item]
    
    /// The currently selected item, if any.
    let selectedItem: Item?
    
    /// The style configuration applied to the list items.
    let style: SelectionStyle
    
    /// A closure that is called when an item is selected.
    let oneSelect: (Item) -> Void
    
    /// An environment variable used to dismiss the view when an item is selected.
    @Environment(\.dismiss) private var dismiss
    
    /// The body of the view, defining the UI structure.
    var body: some View {
        /// A list displaying the available selection items.
        List(item, id: \.proxyId) { item in
            
            /// A button that triggers item selection and dismisses the view.
            Button(action: {
                oneSelect(item) // Calls the selection handler.
                dismiss() // Dismisses the selection sheet or navigation stack.
            }) {
                HStack(spacing: SelectionConstants.Layout.spacing) {
                    /// A placeholder system image.
                    Image(systemName: "home")
                }
            }
        }
    }
}



/// A view that presents a selection interface for benefits.
/// - Parameter item: The type conforming to `MBenefitsProxyProtocol` that represents selectable items.
public struct SelectionView<Item: BenefitsProxyProtocol>: View {
    /// The view model that manages the selection state and business logic.
    @StateObject private var viewModel: SelectionViewModel<Item>
    
    /// Controls the presentation state of the selection sheet.
    @State private var isShowingSheet = false
    
    /// The title displayed in the navigation bar.
    private let title: String
    
    /// Defines how the selection interface should be presented (e.g., modal, push).
    private let presentationType: SelectionPresentationType
    
    /// Creates a new `SelectionView`.
    /// - Parameters:
    ///   - items: The collection of selectable items.
    ///   - delegate: The delegate responsible for handling selection events.
    ///   - title: The title displayed in the navigation bar.
    ///   - presentationType: The method of presenting the selection interface.
    init(items: [Item],
         delegate: SelectionDelegate,
         title: String,
         presentationType: SelectionPresentationType) {
        self.title = title
        self.presentationType = presentationType
        
        // Initialize the repository with the provided items.
        let repository = SelectionRepository(items: items)
        
        // Create a use case that handles selection logic with the repository and delegate.
        let useCase = SelectionUseCase(repository: repository, delegate: delegate)
        
        // Initialize the `StateObject` with a new view model instance.
        // `@StateObject` ensures that the view model persists across view updates.
        self._viewModel = StateObject(wrappedValue: SelectionViewModel(useCase: useCase))
    }
    
        public var body: some View {
            Button(action: {
                isShowingSheet = true
            }) {
                SelectionHeaderView(viewModel: viewModel,
                                    style: presentationType.style)
            }.buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $isShowingSheet) {
                    NavigationStack {
                        SelectionListView(
                            item: viewModel.getItems(),
                            selectedItem: viewModel.selectedItem,
                            style: presentationType.style,
                            oneSelect: viewModel.select(_:)
                        )
                        Text("txt")
                        .navigationTitle(title)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button(SelectionConstants.Strings.closeButton) {
                                    isShowingSheet = false
                                }
                                .foregroundColor(Color.blue)
                            }
                        }
                    }
            }
        }
}





