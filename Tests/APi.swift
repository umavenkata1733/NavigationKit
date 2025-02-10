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





















import SwiftUI

// Core entity representing a cost service in the system
// Conforms to Identifiable for unique identification in lists
public struct CostService: Identifiable {
    /// Unique identifier for the cost service
    public let id: UUID
    
    /// Display title for the service
    public let title: String
    
    /// Detailed description of what the service provides
    public let description: String
    
    /// Icon identifier for visual representation
    public let icon: String
    
    /// Associated action when service is selected
    public let action: CostServiceAction
    
    /// Initializes a new cost service with required properties
    /// - Parameters:
    ///   - id: Optional UUID, defaults to new random UUID
    ///   - title: Service display title
    ///   - description: Service detailed description
    ///   - icon: Icon identifier
    ///   - action: Associated action
    public init(id: UUID = UUID(),
                title: String,
                description: String,
                icon: String,
                action: CostServiceAction) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.action = action
    }
}

/// Defines all possible actions that can be taken on cost services
/// Used for navigation and analytics tracking
public enum CostServiceAction: Equatable {
    /// Medical cost estimation tool
    case medicalEstimator
    
    /// Prescription drug cost estimation
    case drugEstimator
    
    /// ID card viewing and management
    case idCard
    
    /// Toggle to show more options
    case showMore
    
    /// Analytics event name for tracking
    public var analyticsName: String {
        switch self {
        case .medicalEstimator: return "medical_estimator"
        case .drugEstimator: return "drug_estimator"
        case .idCard: return "id_card"
        case .showMore: return "show_more"
        }
    }
}

/// Section types for organizing cost services
public enum CostServiceSectionType {
    /// Section containing cost estimation tools
    case costEstimates
    
    /// Section for ID card management
    case idCard
}

/// Protocol defining cost service business logic
public protocol CostServiceUseCase {
    /// Handles user selection of a service action
    /// - Parameter action: The selected action to handle
    func handleServiceAction(_ action: CostServiceAction)
    
    /// Toggles visibility of additional cost estimates
    func toggleEstimatesExpansion()
}

/// Protocol for cost service data operations
public protocol CostServiceRepository {
    /// Retrieves available cost services
    /// - Returns: Array of cost services
    func getCostServices() -> [CostService]
    
    /// Tracks when a service action is selected
    /// - Parameter action: The action being tracked
    func trackServiceAction(_ action: CostServiceAction)
}

/// Protocol for handling navigation between screens
public protocol CostServiceNavigator {
    /// Navigates to medical cost estimator
    func navigateToMedicalEstimator()
    
    /// Navigates to drug cost estimator
    func navigateToDrugEstimator()
    
    /// Navigates to ID card screen
    func navigateToIDCard()
}

/// Default implementation of cost service use cases
public final class DefaultCostServiceUseCase: CostServiceUseCase {
    /// Repository for data operations
    private let repository: CostServiceRepository
    
    /// Navigator for screen transitions
    private let navigator: CostServiceNavigator
    
    /// Initializes use case with required dependencies
    /// - Parameters:
    ///   - repository: Data repository
    ///   - navigator: Screen navigator
    public init(repository: CostServiceRepository,
                navigator: CostServiceNavigator) {
        self.repository = repository
        self.navigator = navigator
    }
    
    /// Handles user selection of service action
    /// Tracks the action and navigates accordingly
    public func handleServiceAction(_ action: CostServiceAction) {
        repository.trackServiceAction(action)
        
        switch action {
        case .medicalEstimator:
            navigator.navigateToMedicalEstimator()
        case .drugEstimator:
            navigator.navigateToDrugEstimator()
        case .idCard:
            navigator.navigateToIDCard()
        case .showMore:
            toggleEstimatesExpansion()
        }
    }
    
    /// Toggles visibility of additional estimates
    public func toggleEstimatesExpansion() {
        // Toggle implementation
    }
}

/// ViewModel managing cost services view state
@MainActor
public final class CostServicesViewModel: ObservableObject {
    /// Published sections for UI updates
    @Published private(set) var sections: [CostServiceSection]
    
    /// Controls visibility of additional estimates
    @Published public var isEstimatesExpanded = false
    
    /// Use case for business logic
    private let useCase: CostServiceUseCase
    
    /// Initializes view model with sections and use case
    public init(sections: [CostServiceSection],
                useCase: CostServiceUseCase) {
        self.sections = sections
        self.useCase = useCase
    }
    
    /// Handles user action selection
    func handleAction(_ action: CostServiceAction) {
        useCase.handleServiceAction(action)
        if action == .showMore {
            isEstimatesExpanded.toggle()
        }
    }
}

/// Model representing a section of cost services
public struct CostServiceSection: Identifiable {
    /// Unique section identifier
    public let id: UUID
    
    /// Type of services in this section
    public let type: CostServiceSectionType
    
    /// Services contained in this section
    public let services: [CostService]
    
    /// Initializes a new section
    public init(type: CostServiceSectionType,
                services: [CostService]) {
        self.id = UUID()
        self.type = type
        self.services = services
    }
}

/// Main view for displaying cost services
public struct CostServicesView: View {
    /// View model managing state
    @StateObject private var viewModel: CostServicesViewModel
    
    /// Initializes view with view model
    public init(viewModel: CostServicesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    /// Main view body
    public var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(viewModel.sections) { section in
                switch section.type {
                case .costEstimates:
                    CostEstimatesSection(
                        section: section,
                        isExpanded: viewModel.isEstimatesExpanded
                    ) { action in
                        viewModel.handleAction(action)
                    }
                case .idCard:
                    IDCardSection(
                        section: section
                    ) { action in
                        viewModel.handleAction(action)
                    }
                }
            }
        }
    }
}

/// Section displaying cost estimation services
private struct CostEstimatesSection: View {
    /// Section data
    let section: CostServiceSection
    
    /// Controls visibility of additional items
    let isExpanded: Bool
    
    /// Action handler callback
    let onAction: (CostServiceAction) -> Void
    
    /// Section view body
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section title
            Text("Find More Cost Estimates")
                .font(.system(size: 20, weight: .semibold))
                .padding(.horizontal, 16)
            
            // Service list
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(section.services.enumerated()), id: \.element.id) { index, service in
                    if index < 2 || isExpanded {
                        CostServiceCell(service: service, onAction: onAction)
                        
                        if index < (isExpanded ? section.services.count - 1 : 1) {
                            Divider().padding(.leading, 10)
                        }
                    }
                }
            }
            .background(Color(.systemFill))
            .cornerRadius(16)
            .shadow(radius: 2, y: 1)
        }
    }
}

/// Section displaying ID card services
private struct IDCardSection: View {
    /// Section data
    let section: CostServiceSection
    
    /// Action handler callback
    let onAction: (CostServiceAction) -> Void
    
    /// Section view body
    var body: some View {
        VStack(spacing: 0) {
            ForEach(section.services) { service in
                CostServiceCell(service: service, onAction: onAction)
            }
        }
        .background(Color(.systemFill))
        .cornerRadius(16)
        .shadow(radius: 2, y: 1)
    }
}

/// Reusable cell for displaying a cost service
private struct CostServiceCell: View {
    let service: CostService
    let onAction: (CostServiceAction) -> Void
    
    var body: some View {
        Button(action: { onAction(service.action) }) {
            HStack(spacing: csConstants.Layout.Spacing.iconSpacing) {
                // Icon container
                ZStack {
                    Circle()
                        .fill(csConstants.Colors.iconBackground)
                        .frame(width: csConstants.Layout.Size.iconSize,
                               height: csConstants.Layout.Size.iconSize)
                    Image(service.icon)
                        .foregroundColor(csConstants.Colors.iconForeground)
                }
                
                // Text content
                VStack(alignment: .leading, spacing: csConstants.Layout.Spacing.textSpacing) {
                    Text(service.title)
                        .font(csConstants.Typography.cellTitle)
                    Text(service.description)
                        .font(csConstants.Typography.cellDescription)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Chevron indicator
                Image(systemName: csConstants.Images.Icons.chevronRight)
                    .foregroundColor(csConstants.Colors.chevronColor)
            }
            .padding(csConstants.Layout.Padding.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Example screen showing usage
struct ExampleCostServicesScreen: View {
    var body: some View {
        // Setup dependencies
        let repository = MockCostServiceRepository()
        let navigator = MockCostServiceNavigator()
        let useCase = DefaultCostServiceUseCase(
            repository: repository,
            navigator: navigator
        )
        
        // Create test sections
        let estimatesSection = CostServiceSection(
            type: .costEstimates,
            services: [
                CostService(
                    title: "Medical Cost Estimator",
                    description: "Estimate your medical costs",
                    icon: "medical.icon",
                    action: .medicalEstimator
                ),
                CostService(
                    title: "Drug Cost Estimator",
                    description: "Estimate your prescription costs",
                    icon: "drug.icon",
                    action: .drugEstimator
                )
            ]
        )
        
        let idCardSection = CostServiceSection(
            type: .idCard,
            services: [
                CostService(
                    title: "ID Card",
                    description: "View and share your ID card",
                    icon: "id.card.icon",
                    action: .idCard
                )
            ]
        )
        
        // Create view model
        let viewModel = CostServicesViewModel(
            sections: [estimatesSection, idCardSection],
            useCase: useCase
        )
        
        // Return view
        CostServicesView(viewModel: viewModel)
    }
}

/// Mock repository for testing
private final class MockCostServiceRepository: CostServiceRepository {
    /// Returns empty array of services
    func getCostServices() -> [CostService] { [] }
    
    /// No-op implementation for tracking
    func trackServiceAction(_ action: CostServiceAction) { }
}

/// Mock navigator for testing
private final class MockCostServiceNavigator: CostServiceNavigator {
    /// No-op implementation for medical estimator
    func navigateToMedicalEstimator() { }
    
    /// No-op implementation for drug estimator
    func navigateToDrugEstimator() { }
    
    /// No-op implementation for ID card
    func navigateToIDCard() { }
}


// CostServiceConstants.swift

/// Namespace for all Cost Service related constants
public enum CostServiceConstants {
    
    /// Text constants used throughout the module
    public enum Text {
        public enum Titles {
            public static let sectionTitle = "Find More Cost Estimates"
            public static let medicalEstimator = "Medical Cost Estimator"
            public static let drugEstimator = "Drug Cost Estimator"
            public static let idCard = "ID Card"
        }
        
        public enum Descriptions {
            public static let medicalEstimator = "Estimate your medical costs"
            public static let drugEstimator = "Estimate your prescription costs"
            public static let idCard = "View and share your ID card"
        }
        
        public enum Analytics {
            public static let medicalEstimator = "medical_estimator"
            public static let drugEstimator = "drug_estimator"
            public static let idCard = "id_card"
            public static let showMore = "show_more"
            public static let eventName = "cost_service_selected"
        }
    }
    
    /// Image constants used throughout the module
    public enum Images {
        public enum Icons {
            public static let medicalEstimator = "medical.estimator.icon"
            public static let drugEstimator = "drug.estimator.icon"
            public static let idCard = "id.card.icon"
            public static let chevronRight = "chevron.right"
        }
        
    
    }
    
    /// Layout constants for UI components
    public enum Layout {
        public enum Spacing {
            public static let standard: CGFloat = 24
            public static let compact: CGFloat = 20
            public static let minimal: CGFloat = 10
            public static let cell: CGFloat = 16
            public static let iconSpacing: CGFloat = 20
            public static let textSpacing: CGFloat = 4
        }
        
        public enum Size {
            public static let iconSize: CGFloat = 50
            public static let titleFontSize: CGFloat = 20
            public static let cornerRadius: CGFloat = 16
            public static let shadowRadius: CGFloat = 2
            public static let shadowYOffset: CGFloat = 1
        }
        
        public enum Padding {
            public static let horizontal: CGFloat = 16
        }
    }
    
    /// Color constants used in the UI
    public enum Colors {
        public static let iconBackground = Color.blue.opacity(0.1)
        public static let iconForeground = Color.blue
        public static let chevronColor = Color.gray
        public static let backgroundFill = Color(.systemFill)
        public static let shadowColor = Color.black.opacity(0.1)
    }
    
    /// Font styles used in the UI
    public enum Typography {
        public static let sectionTitle = Font.system(size: Layout.Size.titleFontSize, weight: .semibold)
        public static let cellTitle = Font.headline
        public static let cellDescription = Font.subheadline
    }
}

// Usage Extension to make the constants more accessible
public extension View {
    var csConstants: CostServiceConstants.Type { CostServiceConstants.self }
}



// Example of creating service with constants
extension CostService {
    static func createMedicalEstimator() -> CostService {
        CostService(
            title: CostServiceConstants.Text.Titles.medicalEstimator,
            description: CostServiceConstants.Text.Descriptions.medicalEstimator,
            icon: CostServiceConstants.Images.Icons.medicalEstimator,
            action: .medicalEstimator
        )
    }
    
    static func createDrugEstimator() -> CostService {
        CostService(
            title: CostServiceConstants.Text.Titles.drugEstimator,
            description: CostServiceConstants.Text.Descriptions.drugEstimator,
            icon: CostServiceConstants.Images.Icons.drugEstimator,
            action: .drugEstimator
        )
    }
    
    static func createIDCard() -> CostService {
        CostService(
            title: CostServiceConstants.Text.Titles.idCard,
            description: CostServiceConstants.Text.Descriptions.idCard,
            icon: CostServiceConstants.Images.Icons.idCard,
            action: .idCard
        )
    }
}

// Example refactored view model using constants
extension CostServicesViewModel {
    static func createDefault() -> CostServicesViewModel {
        let estimatesSection = CostServiceSection(
            type: .costEstimates,
            services: [
                .createMedicalEstimator(),
                .createDrugEstimator()
            ]
        )
        
        let idCardSection = CostServiceSection(
            type: .idCard,
            services: [
                .createIDCard()
            ]
        )
        
        return CostServicesViewModel(
            sections: [estimatesSection, idCardSection],
            useCase: DefaultCostServiceUseCase(
                repository: MockCostServiceRepository(),
                navigator: MockCostServiceNavigator()
            )
        )
    }
}




















//
//  PromoduleTests.swift
//  PromoduleTests
//
//  Created by Anand on 2/9/25.
//

import XCTest
@testable import Promodule

// MARK: - Mock Objects
final class TestCostServiceRepository: CostServiceRepository {
    var services: [CostService] = []
    var trackedActions: [CostServiceAction] = []
    
    func getCostServices() -> [CostService] {
        return services
    }
    
    func trackServiceAction(_ action: CostServiceAction) {
        trackedActions.append(action)
    }
}

final class TestCostServiceNavigator: CostServiceNavigator {
    var navigatedToMedical = false
    var navigatedToDrug = false
    var navigatedToIDCard = false
    
    func navigateToMedicalEstimator() {
        navigatedToMedical = true
    }
    
    func navigateToDrugEstimator() {
        navigatedToDrug = true
    }
    
    func navigateToIDCard() {
        navigatedToIDCard = true
    }
}

// MARK: - Entity Tests
final class CostServiceTests: XCTestCase {
    func testCostServiceInitialization() {
        // Given
        let id = UUID()
        let title = "Test Service"
        let description = "Test Description"
        let icon = "test.icon"
        let action = CostServiceAction.medicalEstimator
        
        // When
        let service = CostService(
            id: id,
            title: title,
            description: description,
            icon: icon,
            action: action
        )
        
        // Then
        XCTAssertEqual(service.id, id)
        XCTAssertEqual(service.title, title)
        XCTAssertEqual(service.description, description)
        XCTAssertEqual(service.icon, icon)
        XCTAssertEqual(service.action, action)
    }
    
    func testFactoryMethods() {
        // When
        let medical = CostService.createMedicalEstimator()
        let drug = CostService.createDrugEstimator()
        let idCard = CostService.createIDCard()
        
        // Then
        XCTAssertEqual(medical.title, CostServiceConstants.Text.Titles.medicalEstimator)
        XCTAssertEqual(drug.title, CostServiceConstants.Text.Titles.drugEstimator)
        XCTAssertEqual(idCard.title, CostServiceConstants.Text.Titles.idCard)
    }
}

// MARK: - Use Case Tests
final class DefaultCostServiceUseCaseTests: XCTestCase {
    var repository: TestCostServiceRepository!
    var navigator: TestCostServiceNavigator!
    var useCase: DefaultCostServiceUseCase!
    
    override func setUp() {
        super.setUp()
        repository = TestCostServiceRepository()
        navigator = TestCostServiceNavigator()
        useCase = DefaultCostServiceUseCase(
            repository: repository,
            navigator: navigator
        )
    }
    
    func testHandleMedicalEstimatorAction() {
        // When
        useCase.handleServiceAction(.medicalEstimator)
        
        // Then
        XCTAssertTrue(navigator.navigatedToMedical)
        XCTAssertFalse(navigator.navigatedToDrug)
        XCTAssertFalse(navigator.navigatedToIDCard)
        XCTAssertEqual(repository.trackedActions, [.medicalEstimator])
    }
    
    func testHandleDrugEstimatorAction() {
        // When
        useCase.handleServiceAction(.drugEstimator)
        
        // Then
        XCTAssertFalse(navigator.navigatedToMedical)
        XCTAssertTrue(navigator.navigatedToDrug)
        XCTAssertFalse(navigator.navigatedToIDCard)
        XCTAssertEqual(repository.trackedActions, [.drugEstimator])
    }
    
    func testHandleIDCardAction() {
        // When
        useCase.handleServiceAction(.idCard)
        
        // Then
        XCTAssertFalse(navigator.navigatedToMedical)
        XCTAssertFalse(navigator.navigatedToDrug)
        XCTAssertTrue(navigator.navigatedToIDCard)
        XCTAssertEqual(repository.trackedActions, [.idCard])
    }
}

// MARK: - View Model Tests
@MainActor
final class CostServicesViewModelTests: XCTestCase {
    var repository: TestCostServiceRepository!
    var navigator: TestCostServiceNavigator!
    var useCase: DefaultCostServiceUseCase!
    var viewModel: CostServicesViewModel!
    
    @MainActor
    override func setUp() {
        super.setUp()
        repository = TestCostServiceRepository()
        navigator = TestCostServiceNavigator()
        useCase = DefaultCostServiceUseCase(
            repository: repository,
            navigator: navigator
        )
        
        let sections = [
            CostServiceSection(
                type: .costEstimates,
                services: [
                    .createMedicalEstimator(),
                    .createDrugEstimator()
                ]
            )
        ]
        
        viewModel = CostServicesViewModel(
            sections: sections,
            useCase: useCase
        )
    }
    
    func testInitialState() {
        XCTAssertFalse(viewModel.isEstimatesExpanded)
        XCTAssertEqual(viewModel.sections.count, 1)
        XCTAssertEqual(viewModel.sections[0].services.count, 2)
    }
    
    func testShowMoreAction() {
        // Given
        XCTAssertFalse(viewModel.isEstimatesExpanded)
        
        // When
        viewModel.handleAction(.showMore)
        
        // Then
        XCTAssertTrue(viewModel.isEstimatesExpanded)
        
        // When toggle again
        viewModel.handleAction(.showMore)
        
        // Then
        XCTAssertFalse(viewModel.isEstimatesExpanded)
    }
    
    func testNavigationActions() {
        // When
        viewModel.handleAction(.medicalEstimator)
        
        // Then
        XCTAssertTrue(navigator.navigatedToMedical)
        XCTAssertEqual(repository.trackedActions, [.medicalEstimator])
        
        // When
        viewModel.handleAction(.drugEstimator)
        
        // Then
        XCTAssertTrue(navigator.navigatedToDrug)
        XCTAssertEqual(repository.trackedActions, [.medicalEstimator, .drugEstimator])
    }
}

// MARK: - Constants Tests
final class CostServiceConstantsTests: XCTestCase {
    func testTextConstants() {
        XCTAssertEqual(CostServiceConstants.Text.Titles.medicalEstimator,
                       "Medical Cost Estimator")
        XCTAssertEqual(CostServiceConstants.Text.Descriptions.medicalEstimator,
                       "Estimate your medical costs")
        XCTAssertEqual(CostServiceConstants.Text.Analytics.medicalEstimator,
                       "medical_estimator")
    }
    
    func testLayoutConstants() {
        XCTAssertEqual(CostServiceConstants.Layout.Spacing.standard, 24)
        XCTAssertEqual(CostServiceConstants.Layout.Size.iconSize, 50)
        XCTAssertEqual(CostServiceConstants.Layout.Padding.horizontal, 16)
    }
}

// MARK: - Section Tests
final class CostServiceSectionTests: XCTestCase {
    func testSectionInitialization() {
        // Given
        let services = [CostService.createMedicalEstimator()]
        
        // When
        let section = CostServiceSection(
            type: .costEstimates,
            services: services
        )
        
        // Then
        XCTAssertEqual(section.type, .costEstimates)
        XCTAssertEqual(section.services.count, 1)
        XCTAssertNotNil(section.id)
    }
}
