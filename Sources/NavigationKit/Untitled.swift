import SwiftUI

// MARK: - MODELS

/// Model representing a navigation/information item in the UI
public struct BannerItem: Identifiable, Equatable {
    // MARK: - Properties
    
    /// Unique identifier for the banner
    public let id: String
    
    /// Main title text of the banner
    public let title: String
    
    /// Supporting subtitle text or description
    public let subtitle: String
    
    /// SF Symbol name for the banner's icon
    public let iconName: String
    
    /// Optional call-to-action text
    public let actionText: String?
    
    /// Whether the banner should display a navigation arrow
    public let hasNavigationArrow: Bool
    
    /// Visual style of the banner
    public let displayStyle: DisplayStyle
    
    /// Optional navigation route identifier
    public let route: String?
    
    // MARK: - Nested Types
    
    /// Visual style options for banners
    public enum DisplayStyle: String, Codable, Equatable {
        /// Full-width welcome/featured banner
        case banner
        
        /// Compact list item
        case list
        
        /// Card-style item with more visual prominence
        case card
    }
    
    // MARK: - Initialization
    
    /// Creates a new banner item with the specified properties
    ///
    /// - Parameters:
    ///   - id: Unique identifier
    ///   - title: Main title text
    ///   - subtitle: Supporting text or description
    ///   - iconName: SF Symbol name for the icon
    ///   - actionText: Optional call-to-action text
    ///   - hasNavigationArrow: Whether to show a navigation arrow
    ///   - displayStyle: Visual style (banner, list, or card)
    ///   - route: Optional navigation route identifier
    public init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String,
        iconName: String,
        actionText: String? = nil,
        hasNavigationArrow: Bool = false,
        displayStyle: DisplayStyle = .banner,
        route: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.actionText = actionText
        self.hasNavigationArrow = hasNavigationArrow
        self.displayStyle = displayStyle
        self.route = route
    }
}

/// Model for Plan Summary details
public struct PlanSummary: Identifiable, Equatable {
    // MARK: - Properties
    
    /// Unique identifier for the plan
    public let id: String
    
    /// Section title (e.g., "Medical Plan")
    public let title: String
    
    /// Name of the plan (e.g., "Active 2025 Plan - KP CURRENT PLAN")
    public let planName: String
    
    /// Coverage date range (e.g., "01/01/2025 to 12/31/2025")
    public let coverageDates: String
    
    /// Deductible information (e.g., "$2500 individual / $3000 family")
    public let deductibleLimit: String
    
    /// Out-of-pocket maximum information (e.g., "$300 individual / $6000 family")
    public let outOfPocketLimit: String
    
    /// Whether the plan information can be expanded
    public let isExpandable: Bool
    
    // MARK: - Initialization
    
    /// Creates a new plan summary with the specified properties
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the plan
    ///   - title: Section title
    ///   - planName: Full name of the plan
    ///   - coverageDates: Coverage date range text
    ///   - deductibleLimit: Deductible limit text
    ///   - outOfPocketLimit: Out-of-pocket maximum text
    ///   - isExpandable: Whether the plan can be expanded to show more details
    public init(
        id: String = UUID().uuidString,
        title: String,
        planName: String,
        coverageDates: String,
        deductibleLimit: String,
        outOfPocketLimit: String,
        isExpandable: Bool = true
    ) {
        self.id = id
        self.title = title
        self.planName = planName
        self.coverageDates = coverageDates
        self.deductibleLimit = deductibleLimit
        self.outOfPocketLimit = outOfPocketLimit
        self.isExpandable = isExpandable
    }
    
    // MARK: - Equatable
    
    public static func == (lhs: PlanSummary, rhs: PlanSummary) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.planName == rhs.planName &&
        lhs.coverageDates == rhs.coverageDates &&
        lhs.deductibleLimit == rhs.deductibleLimit &&
        lhs.outOfPocketLimit == rhs.outOfPocketLimit &&
        lhs.isExpandable == rhs.isExpandable
    }
}

/// Factory Methods for PlanSummary
extension PlanSummary {
    /// Creates a placeholder plan summary for previews or testing
    public static func placeholder() -> PlanSummary {
        PlanSummary(
            title: "Medical Plan",
            planName: "Sample Plan",
            coverageDates: "01/01/2025 to 12/31/2025",
            deductibleLimit: "$2500 individual / $3000 family",
            outOfPocketLimit: "$300 individual / $6000 family"
        )
    }
}

/// Model for Out of Network section details
public struct OutOfNetworkInfo: Identifiable, Equatable {
    // MARK: - Properties
    
    /// Unique identifier for this information
    public let id: String
    
    /// Section title (e.g., "Out of Network")
    public let title: String
    
    /// Informational text describing out-of-network coverage
    public let description: String
 
    
    /// Route identifier for navigation (if applicable)
    public let route: String?
    
    // MARK: - Initialization
    
    /// Creates a new out-of-network info instance
    ///
    /// - Parameters:
    ///   - id: Unique identifier
    ///   - title: Section title
    ///   - description: Informational text
    ///   - actionText: Optional text for call-to-action
    ///   - route: Optional navigation route identifier
    public init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        route: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.route = route
    }
    
    // MARK: - Equatable
    
    public static func == (lhs: OutOfNetworkInfo, rhs: OutOfNetworkInfo) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.route == rhs.route
    }
}

/// Factory Methods for OutOfNetworkInfo
extension OutOfNetworkInfo {
    /// Creates a placeholder out-of-network info for previews or testing
    public static func placeholder() -> OutOfNetworkInfo {
        OutOfNetworkInfo(
            title: "Out of Network",
            description: "You have X of X visits/services available for covered out-of-network medical care."
        )
    }
}


// MARK: - STYLING & CONFIGURATION

/// Central style configuration for consistent UI appearance
public struct BannerStyleConfiguration {
    // MARK: - Properties
    
    /// Primary color used for icons, buttons, and highlighted elements
    public let primaryColor: Color
    
    /// Secondary color used for supporting text and secondary elements
    public let secondaryColor: Color
    
    /// SF Symbol name for the navigation arrow icon
    public let arrowIconImageName: String
    
    /// Standard text color for labels
    public let labelColor: Color
    
    /// Standard text color for values
    public let valueColor: Color
    
    /// Background color for sections
    public let sectionBackgroundColor: Color
    
    /// Background color for cards
    public let cardBackgroundColor: Color
    
    /// Corner radius for card elements
    public let cornerRadius: CGFloat
    
    // MARK: - Initialization
    
    /// Creates a new style configuration with the specified properties or defaults
    ///
    /// - Parameters:
    ///   - primaryColor: Color for icons and primary elements
    ///   - secondaryColor: Color for supporting text
    ///   - arrowIconImageName: SF Symbol name for navigation arrows
    ///   - labelColor: Color for label text
    ///   - valueColor: Color for value text
    ///   - sectionBackgroundColor: Background color for sections
    ///   - cardBackgroundColor: Background color for cards
    ///   - cornerRadius: Corner radius for rounded elements
    public init(
        primaryColor: Color = .blue,
        secondaryColor: Color = .gray,
        arrowIconImageName: String = "chevron.right",
        labelColor: Color = .gray,
        valueColor: Color = .black,
        sectionBackgroundColor: Color = Color(.systemGray6),
        cardBackgroundColor: Color = .white,
        cornerRadius: CGFloat = 12
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.arrowIconImageName = arrowIconImageName
        self.labelColor = labelColor
        self.valueColor = valueColor
        self.sectionBackgroundColor = sectionBackgroundColor
        self.cardBackgroundColor = cardBackgroundColor
        self.cornerRadius = cornerRadius
    }
}

// MARK: - View Modifiers

/// Modifier for section-style views
struct SectionModifier: ViewModifier {
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(backgroundColor)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

/// Modifier for card-style views
struct CardModifier: ViewModifier {
    let backgroundColor: Color
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .padding(.horizontal, 20)
    }
}

// MARK: - View Extensions

extension View {
    /// Applies section styling from a StyleConfiguration
    func sectionStyle(_ config: BannerStyleConfiguration) -> some View {
        self.modifier(SectionModifier(backgroundColor: config.sectionBackgroundColor))
    }
    
    /// Applies card styling from a StyleConfiguration
    func cardStyle(_ config: BannerStyleConfiguration) -> some View {
        self.modifier(CardModifier(
            backgroundColor: config.cardBackgroundColor,
            cornerRadius: config.cornerRadius
        ))
    }
}

// MARK: - Text Extensions

extension Text {
    /// Applies standard label styling from a StyleConfiguration
    func labelStyle(_ config: BannerStyleConfiguration) -> Text {
        self.font(.body)
            .foregroundColor(config.labelColor)
    }
    
    /// Applies standard value styling from a StyleConfiguration
    func valueStyle(_ config: BannerStyleConfiguration) -> Text {
        self.font(.body)
            .foregroundColor(config.valueColor)
    }
    
    /// Applies title styling from a StyleConfiguration
    func titleStyle(_ config: BannerStyleConfiguration) -> Text {
        self.font(.title3)
            .fontWeight(.bold)
            .foregroundColor(config.valueColor)
    }
}

// MARK: - UI COMPONENTS

/// Reusable component for label-value information fields
struct InfoFieldView: View {
    let label: String
    let value: String
    let showInfoIcon: Bool
    let styleConfig: BannerStyleConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(label)
                    .labelStyle(styleConfig)
                
                if showInfoIcon {
                    Image(systemName: "info.circle")
                        .font(.body)
                        .foregroundColor(styleConfig.primaryColor)
                        .accessibilityLabel("More information about \(label)")
                }
            }
            
            Text(value)
                .valueStyle(styleConfig)
        }
    }
}

/// Row component for displaying a single banner item
public struct BannerItemRow: View {
    // Properties
    let item: BannerItem
    let styleConfig: BannerStyleConfiguration
    let onTap: (() -> Void)?
    
    public init(
        item: BannerItem,
        styleConfig: BannerStyleConfiguration,
        onTap: (() -> Void)? = nil
    ) {
        self.item = item
        self.styleConfig = styleConfig
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: {
            onTap?()
        }) {
            HStack(spacing: 16) {
                // Category icon
                Image(systemName: item.iconName)
                    .frame(width: 24, height: 24)
                    .foregroundColor(styleConfig.primaryColor)
                    .accessibilityHidden(true)
                
                // Category title
                Text(item.title)
                    .font(.body)
                    .foregroundColor(styleConfig.valueColor)
                
                Spacer()
                
                // Optional subtitle text
                if !item.subtitle.isEmpty {
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundColor(styleConfig.secondaryColor)
                }
                
                // Optional navigation arrow
                if item.hasNavigationArrow {
                    Image(systemName: styleConfig.arrowIconImageName)
                        .foregroundColor(Color(.systemGray3))
                        .accessibilityHidden(true)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .accessibility(label: Text(item.title))
        .accessibility(hint: Text("Select to view details"))
    }
}

/// View component for displaying plan summary information
public struct PlanSummaryView: View {
    // MARK: - Properties
    
    /// Data model to be displayed
    private let planSummary: PlanSummary
    
    /// Style configuration
    private let styleConfig: BannerStyleConfiguration
    
    // MARK: - Initialization
    
    /// Creates a new plan summary view with the specified plan and style
    ///
    /// - Parameters:
    ///   - planSummary: Plan data to display
    ///   - styleConfig: Style configuration for consistent appearance
    public init(
        planSummary: PlanSummary,
        styleConfig: BannerStyleConfiguration = BannerStyleConfiguration()
    ) {
        self.planSummary = planSummary
        self.styleConfig = styleConfig
    }
    
    // MARK: - View Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Title and Plan Name
            VStack(alignment: .leading, spacing: 8) {
                Text(planSummary.title)
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundColor(Color.gray)
                
                Text(planSummary.planName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            
            // Coverage Dates
            VStack(alignment: .leading, spacing: 6) {
                Text("Coverage Dates")
                    .font(.title3)
                    .foregroundColor(Color.gray)
                
                Text(planSummary.coverageDates)
                    .font(.body)
                    .foregroundColor(.black)
            }
            .padding(.bottom, 4)
            
            // Deductible
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Text("Deductible Limit")
                        .font(.title3)
                        .foregroundColor(Color.gray)
                    
                    Image(systemName: "info.circle")
                        .font(.body)
                        .foregroundColor(.blue)
                        .accessibilityLabel("More information about Deductible Limit")
                }
                
                Text(planSummary.deductibleLimit)
                    .font(.body)
                    .foregroundColor(.black)
            }
            .padding(.bottom, 4)
            
            // Out-of-Pocket
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Text("Out-of-Pocket Limit")
                        .font(.title3)
                        .foregroundColor(Color.gray)
                    
                    Image(systemName: "info.circle")
                        .font(.body)
                        .foregroundColor(.blue)
                        .accessibilityLabel("More information about Out-of-Pocket Limit")
                }
                
                Text(planSummary.outOfPocketLimit)
                    .font(.body)
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 24)
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.horizontal)
    }
}

/// View component for displaying out-of-network information
public struct OutOfNetworkView: View {
    // MARK: - Properties
    
    /// Data model to display
    private let outOfNetworkInfo: OutOfNetworkInfo
    
    /// Style configuration for consistent appearance
    private let styleConfig: BannerStyleConfiguration
    
    /// Action to perform when tapping "Learn More" (if provided)
    private let action: (() -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a new out-of-network view with the specified info and style
    ///
    /// - Parameters:
    ///   - outOfNetworkInfo: Information to display
    ///   - styleConfig: Style configuration for consistent appearance
    ///   - action: Optional action to perform when tapping "Learn More"
    public init(
        outOfNetworkInfo: OutOfNetworkInfo,
        styleConfig: BannerStyleConfiguration = BannerStyleConfiguration(),
        action: (() -> Void)? = nil
    ) {
        self.outOfNetworkInfo = outOfNetworkInfo
        self.styleConfig = styleConfig
        self.action = action
    }
    
    // MARK: - View Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title with info icon
            HStack {
                Text(outOfNetworkInfo.title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(styleConfig.valueColor)
                
                Image(systemName: "info.circle")
                    .font(.body)
                    .foregroundColor(styleConfig.primaryColor)
                    .accessibilityLabel("More information about out-of-network coverage")
            }
            
            // Description text
            Text(outOfNetworkInfo.description)
                .font(.body)
                .foregroundColor(styleConfig.secondaryColor)
                .padding(.bottom, 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(styleConfig.sectionBackgroundColor)
        .edgesIgnoringSafeArea(.horizontal)
    }
}

/// View for displaying a list of selectable categories
public struct CategoryListView: View {
    // MARK: - Properties
    
    /// Instructional text displayed above the list
    private let instructionText: String
    
    /// Items to display in the list
    private let items: [BannerItem]
    
    /// Style configuration for consistent appearance
    private let styleConfig: BannerStyleConfiguration
    
    /// Action to perform when an item is selected
    private let onItemSelected: ((BannerItem) -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a new category list view with the specified items and style
    ///
    /// - Parameters:
    ///   - instructionText: Text displayed above the list
    ///   - items: Items to display in the list
    ///   - styleConfig: Style configuration for consistent appearance
    ///   - onItemSelected: Optional action to perform when an item is selected
    public init(
        instructionText: String,
        items: [BannerItem],
        styleConfig: BannerStyleConfiguration = BannerStyleConfiguration(),
        onItemSelected: ((BannerItem) -> Void)? = nil
    ) {
        self.instructionText = instructionText
        self.items = items
        self.styleConfig = styleConfig
        self.onItemSelected = onItemSelected
    }
    
    // MARK: - View Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Only show content if there are items
            if !items.isEmpty {
                VStack(spacing: 0) {
                    // Instruction text with consistent styling
                    Text(instructionText)
                        .font(.body)
                        .foregroundColor(styleConfig.labelColor)
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 20)
                        .accessibilityAddTraits(.isHeader)
                    
                    // List of category items
                    ForEach(items) { item in
                        BannerItemRow(
                            item: item,
                            styleConfig: styleConfig,
                            onTap: {
                                onItemSelected?(item)
                            }
                        )
                        
                        // Add divider between items (except after last item)
                        if item.id != items.last?.id {
                            Divider()
                                .padding(.leading, 20)
                        }
                    }
                }
                .background(styleConfig.cardBackgroundColor)
                .cornerRadius(styleConfig.cornerRadius)
                .padding(.horizontal, 8)
                .padding(.bottom, 24)
            } else {
                // Empty state
                Text("No categories available")
                    .font(.body)
                    .foregroundColor(styleConfig.secondaryColor)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(styleConfig.cardBackgroundColor)
                    .cornerRadius(styleConfig.cornerRadius)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
        }
        .background(styleConfig.sectionBackgroundColor)
    }
}



// MARK: - Active Plan Model

/// Model for Active Plan section details
public struct ActivePlanInfo: Identifiable, Equatable {
    // MARK: - Properties
    
    /// Unique identifier for this information
    public let id: String
    
    /// Title of the active plan
    public let title: String
    
    /// Optional subtitle or additional information
    public let subtitle: String?
    
    // MARK: - Initialization
    
    /// Creates a new active plan info instance
    ///
    /// - Parameters:
    ///   - id: Unique identifier
    ///   - title: Plan title text
    ///   - subtitle: Optional subtitle text
    public init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
    }
    
    // MARK: - Equatable
    
    public static func == (lhs: ActivePlanInfo, rhs: ActivePlanInfo) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle
    }
}

// MARK: - Factory Methods

extension ActivePlanInfo {
    /// Creates a placeholder active plan info for previews or testing
    public static func placeholder() -> ActivePlanInfo {
        ActivePlanInfo(
            title: "Active 2025 Plan",
            subtitle: "KP CURRENT PLAN"
        )
    }
}

// MARK: - Active Plan View

/// View component for displaying active plan information
public struct ActivePlanView: View {
    // MARK: - Properties
    
    /// Data model to display
    private let activePlanInfo: ActivePlanInfo
    
    /// Style configuration for consistent appearance
    private let styleConfig: BannerStyleConfiguration
    
    // MARK: - Initialization
    
    /// Creates a new active plan view with the specified info and style
    ///
    /// - Parameters:
    ///   - activePlanInfo: Information to display
    ///   - styleConfig: Style configuration for consistent appearance
    public init(
        activePlanInfo: ActivePlanInfo,
        styleConfig: BannerStyleConfiguration = BannerStyleConfiguration()
    ) {
        self.activePlanInfo = activePlanInfo
        self.styleConfig = styleConfig
    }
    
    // MARK: - View Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            Text(activePlanInfo.title)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(styleConfig.valueColor)
            
            // Optional subtitle
            if let subtitle = activePlanInfo.subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(styleConfig.secondaryColor)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(styleConfig.sectionBackgroundColor)
        .edgesIgnoringSafeArea(.horizontal)
    }
}


// MARK: - Updated Container View

/// Container view for combining all components (without Active Plan)
public struct MedicalPlanContainerView: View {
    // MARK: - Properties
    
    /// Unified data model
    private let planData: MedicalPlanData
    
    /// Style configuration
    private let styleConfig: BannerStyleConfiguration
    
    /// Visible sections enumeration
    public enum SectionType {
        case planSummary, outOfNetwork, categories
    }
    
    /// Set of visible sections
    private let visibleSections: Set<SectionType>
    
    /// Category selection handler
    private let onCategorySelected: ((BannerItem) -> Void)?
    
    /// Out-of-network action handler
    private let onOutOfNetworkAction: (() -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a new medical plan container view
    ///
    /// - Parameters:
    ///   - planData: Unified data model
    ///   - styleConfig: Style configuration
    ///   - visibleSections: Set of sections to display
    ///   - onCategorySelected: Handler for category selection
    ///   - onOutOfNetworkAction: Handler for out-of-network action
    public init(
        planData: MedicalPlanData,
        styleConfig: BannerStyleConfiguration = BannerStyleConfiguration(),
        visibleSections: Set<SectionType> = [.planSummary, .outOfNetwork, .categories],
        onCategorySelected: ((BannerItem) -> Void)? = nil,
        onOutOfNetworkAction: (() -> Void)? = nil
    ) {
        self.planData = planData
        self.styleConfig = styleConfig
        self.visibleSections = visibleSections
        self.onCategorySelected = onCategorySelected
        self.onOutOfNetworkAction = onOutOfNetworkAction
    }
    
    // MARK: - View Body
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Plan Summary Section (conditionally shown)
                if visibleSections.contains(.planSummary) {
                    PlanSummaryView(
                        planSummary: planData.planSummary,
                        styleConfig: styleConfig
                    )
                }
                
                // Out of Network Section (conditionally shown)
                if visibleSections.contains(.outOfNetwork),
                   let info = planData.outOfNetworkInfo {
                    OutOfNetworkView(
                        outOfNetworkInfo: info,
                        styleConfig: styleConfig,
                        action: onOutOfNetworkAction
                    )
                }
                
                // Category List Section (conditionally shown)
                if visibleSections.contains(.categories),
                   !planData.categories.isEmpty {
                    CategoryListView(
                        instructionText: planData.instructionText,
                        items: planData.categories,
                        styleConfig: styleConfig,
                        onItemSelected: onCategorySelected
                    )
                }
            }
            .background(styleConfig.sectionBackgroundColor)
        }
        .edgesIgnoringSafeArea(.horizontal)
    }
}

// MARK: - Updated Medical Plan Data Model (Remove activePlanInfo)

/// Simplified medical plan data model
public struct MedicalPlanData {
    /// Plan summary information
    public let planSummary: PlanSummary
    
    /// Optional out-of-network information
    public let outOfNetworkInfo: OutOfNetworkInfo?
    
    /// Category items for selection
    public let categories: [BannerItem]
    
    /// Instructional text for the category section
    public let instructionText: String
    
    /// Creates a new medical plan data instance
    ///
    /// - Parameters:
    ///   - planSummary: Plan summary information
    ///   - outOfNetworkInfo: Optional out-of-network information
    ///   - categories: Category items for selection
    ///   - instructionText: Instructional text for the category section
    public init(
        planSummary: PlanSummary,
        outOfNetworkInfo: OutOfNetworkInfo? = nil,
        categories: [BannerItem] = [],
        instructionText: String = "Select a category below to learn about related services covered under your plan."
    ) {
        self.planSummary = planSummary
        self.outOfNetworkInfo = outOfNetworkInfo
        self.categories = categories
        self.instructionText = instructionText
    }
}

// MARK: - Updated Example Implementation

/// Updated example implementation showing how to use the components
public struct ContentView: View {
    // Style configuration
    let styleConfig = BannerStyleConfiguration(
        primaryColor: .blue,
        secondaryColor: .gray,
        arrowIconImageName: "chevron.right",
        labelColor: .gray,
        valueColor: .black,
        sectionBackgroundColor: Color(.systemGray6),
        cardBackgroundColor: .white,
        cornerRadius: 12
    )
    
    // Sample data
    let planData = MedicalPlanData(
        planSummary: PlanSummary(
            title: "Medical Plan",
            planName: "Active 2025 Plan - KP CURRENT PLAN",
            coverageDates: "01/01/2025 to 12/31/2025",
            deductibleLimit: "$2500 individual / $3000 family",
            outOfPocketLimit: "$300 individual / $6000 family"
        ),
        outOfNetworkInfo: OutOfNetworkInfo(
            title: "Out of Network",
            description: "You have X of X visits/services available for covered out-of-network medical care."
        ),
        categories: [
            BannerItem(
                id: "primary-care",
                title: "Primary Care",
                subtitle: "",
                iconName: "doc.text",
                hasNavigationArrow: true,
                displayStyle: .list
            ),
            BannerItem(
                id: "specialty-care",
                title: "Specialty Care",
                subtitle: "",
                iconName: "doc.plaintext",
                hasNavigationArrow: true,
                displayStyle: .list
            ),
            BannerItem(
                id: "labs-imaging",
                title: "Labs & Imaging",
                subtitle: "",
                iconName: "cross.vial",
                hasNavigationArrow: true,
                displayStyle: .list
            ),
            BannerItem(
                id: "mental-health",
                title: "Mental Health",
                subtitle: "",
                iconName: "brain",
                hasNavigationArrow: true,
                displayStyle: .list
            )
        ],
        instructionText: "Select a category below to learn about related services covered under your plan."
    )
    
    public var body: some View {
        MedicalPlanContainerView(
            planData: planData,
            styleConfig: styleConfig,
            onCategorySelected: { item in
                print("Selected: \(item.title)")
                // Handle navigation or other actions
            },
            onOutOfNetworkAction: {
                print("Out-of-network action triggered")
                // Show more information or navigate
            }
        )
    }
}















///










import XCTest
import SwiftUI
@testable import YourModuleName // Replace with your actual module name

final class ModelTests: XCTestCase {
    
    // MARK: - BannerItem Tests
    
    func testBannerItemInitialization() {
        // Given
        let id = "test-id"
        let title = "Test Title"
        let subtitle = "Test Subtitle"
        let iconName = "doc.text"
        let actionText = "Learn More"
        let hasNavigationArrow = true
        let displayStyle = BannerItem.DisplayStyle.card
        let route = "test/route"
        
        // When
        let bannerItem = BannerItem(
            id: id,
            title: title,
            subtitle: subtitle,
            iconName: iconName,
            actionText: actionText,
            hasNavigationArrow: hasNavigationArrow,
            displayStyle: displayStyle,
            route: route
        )
        
        // Then
        XCTAssertEqual(bannerItem.id, id)
        XCTAssertEqual(bannerItem.title, title)
        XCTAssertEqual(bannerItem.subtitle, subtitle)
        XCTAssertEqual(bannerItem.iconName, iconName)
        XCTAssertEqual(bannerItem.actionText, actionText)
        XCTAssertEqual(bannerItem.hasNavigationArrow, hasNavigationArrow)
        XCTAssertEqual(bannerItem.displayStyle, displayStyle)
        XCTAssertEqual(bannerItem.route, route)
    }
    
    func testBannerItemDefaultValues() {
        // Given
        let title = "Test Title"
        let subtitle = "Test Subtitle"
        let iconName = "doc.text"
        
        // When
        let bannerItem = BannerItem(
            title: title,
            subtitle: subtitle,
            iconName: iconName
        )
        
        // Then
        XCTAssertFalse(bannerItem.id.isEmpty)
        XCTAssertEqual(bannerItem.title, title)
        XCTAssertEqual(bannerItem.subtitle, subtitle)
        XCTAssertEqual(bannerItem.iconName, iconName)
        XCTAssertNil(bannerItem.actionText)
        XCTAssertFalse(bannerItem.hasNavigationArrow)
        XCTAssertEqual(bannerItem.displayStyle, .banner)
        XCTAssertNil(bannerItem.route)
    }
    
    func testBannerItemDisplayStyleEquality() {
        // Given
        let banner = BannerItem.DisplayStyle.banner
        let list = BannerItem.DisplayStyle.list
        let card = BannerItem.DisplayStyle.card
        
        // Then
        XCTAssertEqual(banner, .banner)
        XCTAssertEqual(list, .list)
        XCTAssertEqual(card, .card)
        XCTAssertNotEqual(banner, list)
        XCTAssertNotEqual(banner, card)
        XCTAssertNotEqual(list, card)
    }
    
    // MARK: - PlanSummary Tests
    
    func testPlanSummaryInitialization() {
        // Given
        let id = "test-id"
        let title = "Medical Plan"
        let planName = "Test Plan Name"
        let coverageDates = "01/01/2025 to 12/31/2025"
        let deductibleLimit = "$2500 individual / $3000 family"
        let outOfPocketLimit = "$300 individual / $6000 family"
        let isExpandable = true
        
        // When
        let planSummary = PlanSummary(
            id: id,
            title: title,
            planName: planName,
            coverageDates: coverageDates,
            deductibleLimit: deductibleLimit,
            outOfPocketLimit: outOfPocketLimit,
            isExpandable: isExpandable
        )
        
        // Then
        XCTAssertEqual(planSummary.id, id)
        XCTAssertEqual(planSummary.title, title)
        XCTAssertEqual(planSummary.planName, planName)
        XCTAssertEqual(planSummary.coverageDates, coverageDates)
        XCTAssertEqual(planSummary.deductibleLimit, deductibleLimit)
        XCTAssertEqual(planSummary.outOfPocketLimit, outOfPocketLimit)
        XCTAssertEqual(planSummary.isExpandable, isExpandable)
    }
    
    func testPlanSummaryDefaultValues() {
        // Given
        let title = "Medical Plan"
        let planName = "Test Plan Name"
        let coverageDates = "01/01/2025 to 12/31/2025"
        let deductibleLimit = "$2500 individual / $3000 family"
        let outOfPocketLimit = "$300 individual / $6000 family"
        
        // When
        let planSummary = PlanSummary(
            title: title,
            planName: planName,
            coverageDates: coverageDates,
            deductibleLimit: deductibleLimit,
            outOfPocketLimit: outOfPocketLimit
        )
        
        // Then
        XCTAssertFalse(planSummary.id.isEmpty)
        XCTAssertEqual(planSummary.title, title)
        XCTAssertEqual(planSummary.planName, planName)
        XCTAssertEqual(planSummary.coverageDates, coverageDates)
        XCTAssertEqual(planSummary.deductibleLimit, deductibleLimit)
        XCTAssertEqual(planSummary.outOfPocketLimit, outOfPocketLimit)
        XCTAssertTrue(planSummary.isExpandable)
    }
    
    func testPlanSummaryEquality() {
        // Given
        let plan1 = PlanSummary(
            id: "id1",
            title: "Medical Plan",
            planName: "Plan A",
            coverageDates: "01/01/2025 to 12/31/2025",
            deductibleLimit: "$2500 individual / $3000 family",
            outOfPocketLimit: "$300 individual / $6000 family"
        )
        
        let plan2 = PlanSummary(
            id: "id1",
            title: "Medical Plan",
            planName: "Plan A",
            coverageDates: "01/01/2025 to 12/31/2025",
            deductibleLimit: "$2500 individual / $3000 family",
            outOfPocketLimit: "$300 individual / $6000 family"
        )
        
        let plan3 = PlanSummary(
            id: "id2",
            title: "Medical Plan",
            planName: "Plan B",
            coverageDates: "01/01/2025 to 12/31/2025",
            deductibleLimit: "$2500 individual / $3000 family",
            outOfPocketLimit: "$300 individual / $6000 family"
        )
        
        // Then
        XCTAssertEqual(plan1, plan2)
        XCTAssertNotEqual(plan1, plan3)
    }
    
    func testPlanSummaryPlaceholder() {
        // When
        let placeholder = PlanSummary.placeholder()
        
        // Then
        XCTAssertEqual(placeholder.title, "Medical Plan")
        XCTAssertEqual(placeholder.planName, "Sample Plan")
        XCTAssertEqual(placeholder.coverageDates, "01/01/2025 to 12/31/2025")
        XCTAssertEqual(placeholder.deductibleLimit, "$2500 individual / $3000 family")
        XCTAssertEqual(placeholder.outOfPocketLimit, "$300 individual / $6000 family")
        XCTAssertTrue(placeholder.isExpandable)
    }
    
    // MARK: - OutOfNetworkInfo Tests
    
    func testOutOfNetworkInfoInitialization() {
        // Given
        let id = "test-id"
        let title = "Out of Network"
        let description = "Test description"
        let route = "test/route"
        
        // When
        let info = OutOfNetworkInfo(
            id: id,
            title: title,
            description: description,
            route: route
        )
        
        // Then
        XCTAssertEqual(info.id, id)
        XCTAssertEqual(info.title, title)
        XCTAssertEqual(info.description, description)
        XCTAssertEqual(info.route, route)
    }
    
    func testOutOfNetworkInfoDefaultValues() {
        // Given
        let title = "Out of Network"
        let description = "Test description"
        
        // When
        let info = OutOfNetworkInfo(
            title: title,
            description: description
        )
        
        // Then
        XCTAssertFalse(info.id.isEmpty)
        XCTAssertEqual(info.title, title)
        XCTAssertEqual(info.description, description)
        XCTAssertNil(info.route)
    }
    
    func testOutOfNetworkInfoEquality() {
        // Given
        let info1 = OutOfNetworkInfo(
            id: "id1",
            title: "Out of Network",
            description: "Description A"
        )
        
        let info2 = OutOfNetworkInfo(
            id: "id1",
            title: "Out of Network",
            description: "Description A"
        )
        
        let info3 = OutOfNetworkInfo(
            id: "id2",
            title: "Out of Network",
            description: "Description B"
        )
        
        // Then
        XCTAssertEqual(info1, info2)
        XCTAssertNotEqual(info1, info3)
    }
    
    func testOutOfNetworkInfoPlaceholder() {
        // When
        let placeholder = OutOfNetworkInfo.placeholder()
        
        // Then
        XCTAssertEqual(placeholder.title, "Out of Network")
        XCTAssertEqual(placeholder.description, "You have X of X visits/services available for covered out-of-network medical care.")
        XCTAssertNil(placeholder.route)
    }
    
    // MARK: - ActivePlanInfo Tests
    
    func testActivePlanInfoInitialization() {
        // Given
        let id = "test-id"
        let title = "Active Plan"
        let subtitle = "Test Subtitle"
        
        // When
        let info = ActivePlanInfo(
            id: id,
            title: title,
            subtitle: subtitle
        )
        
        // Then
        XCTAssertEqual(info.id, id)
        XCTAssertEqual(info.title, title)
        XCTAssertEqual(info.subtitle, subtitle)
    }
    
    func testActivePlanInfoDefaultValues() {
        // Given
        let title = "Active Plan"
        
        // When
        let info = ActivePlanInfo(
            title: title
        )
        
        // Then
        XCTAssertFalse(info.id.isEmpty)
        XCTAssertEqual(info.title, title)
        XCTAssertNil(info.subtitle)
    }
    
    func testActivePlanInfoEquality() {
        // Given
        let info1 = ActivePlanInfo(
            id: "id1",
            title: "Active Plan A",
            subtitle: "Subtitle A"
        )
        
        let info2 = ActivePlanInfo(
            id: "id1",
            title: "Active Plan A",
            subtitle: "Subtitle A"
        )
        
        let info3 = ActivePlanInfo(
            id: "id2",
            title: "Active Plan B",
            subtitle: "Subtitle B"
        )
        
        // Then
        XCTAssertEqual(info1, info2)
        XCTAssertNotEqual(info1, info3)
    }
    
    func testActivePlanInfoPlaceholder() {
        // When
        let placeholder = ActivePlanInfo.placeholder()
        
        // Then
        XCTAssertEqual(placeholder.title, "Active 2025 Plan")
        XCTAssertEqual(placeholder.subtitle, "KP CURRENT PLAN")
    }
    
    // MARK: - BannerStyleConfiguration Tests
    
    func testBannerStyleConfigurationInitialization() {
        // Given
        let primaryColor = Color.red
        let secondaryColor = Color.blue
        let arrowIconImageName = "arrow.right"
        let labelColor = Color.green
        let valueColor = Color.yellow
        let sectionBackgroundColor = Color.purple
        let cardBackgroundColor = Color.orange
        let cornerRadius: CGFloat = 16
        
        // When
        let config = BannerStyleConfiguration(
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            arrowIconImageName: arrowIconImageName,
            labelColor: labelColor,
            valueColor: valueColor,
            sectionBackgroundColor: sectionBackgroundColor,
            cardBackgroundColor: cardBackgroundColor,
            cornerRadius: cornerRadius
        )
        
        // Then
        XCTAssertEqual(config.primaryColor, primaryColor)
        XCTAssertEqual(config.secondaryColor, secondaryColor)
        XCTAssertEqual(config.arrowIconImageName, arrowIconImageName)
        XCTAssertEqual(config.labelColor, labelColor)
        XCTAssertEqual(config.valueColor, valueColor)
        XCTAssertEqual(config.sectionBackgroundColor, sectionBackgroundColor)
        XCTAssertEqual(config.cardBackgroundColor, cardBackgroundColor)
        XCTAssertEqual(config.cornerRadius, cornerRadius)
    }
    
    func testBannerStyleConfigurationDefaultValues() {
        // When
        let config = BannerStyleConfiguration()
        
        // Then
        XCTAssertEqual(config.primaryColor, .blue)
        XCTAssertEqual(config.secondaryColor, .gray)
        XCTAssertEqual(config.arrowIconImageName, "chevron.right")
        XCTAssertEqual(config.labelColor, .gray)
        XCTAssertEqual(config.valueColor, .black)
        XCTAssertEqual(config.sectionBackgroundColor, Color(.systemGray6))
        XCTAssertEqual(config.cardBackgroundColor, .white)
        XCTAssertEqual(config.cornerRadius, 12)
    }
    
    // MARK: - MedicalPlanData Tests
    
    func testMedicalPlanDataInitialization() {
        // Given
        let planSummary = PlanSummary.placeholder()
        let outOfNetworkInfo = OutOfNetworkInfo.placeholder()
        let categories = [
            BannerItem(title: "Primary Care", subtitle: "", iconName: "doc.text"),
            BannerItem(title: "Specialty Care", subtitle: "", iconName: "doc.plaintext")
        ]
        let instructionText = "Custom instruction text"
        
        // When
        let planData = MedicalPlanData(
            planSummary: planSummary,
            outOfNetworkInfo: outOfNetworkInfo,
            categories: categories,
            instructionText: instructionText
        )
        
        // Then
        XCTAssertEqual(planData.planSummary, planSummary)
        XCTAssertEqual(planData.outOfNetworkInfo, outOfNetworkInfo)
        XCTAssertEqual(planData.categories.count, 2)
        XCTAssertEqual(planData.categories[0].title, "Primary Care")
        XCTAssertEqual(planData.categories[1].title, "Specialty Care")
        XCTAssertEqual(planData.instructionText, instructionText)
    }
    
    func testMedicalPlanDataDefaultValues() {
        // Given
        let planSummary = PlanSummary.placeholder()
        
        // When
        let planData = MedicalPlanData(
            planSummary: planSummary
        )
        
        // Then
        XCTAssertEqual(planData.planSummary, planSummary)
        XCTAssertNil(planData.outOfNetworkInfo)
        XCTAssertTrue(planData.categories.isEmpty)
        XCTAssertEqual(planData.instructionText, "Select a category below to learn about related services covered under your plan.")
    }
}

// MARK: - View Tests

final class ViewTests: XCTestCase {
    
    // MARK: - BannerItemRow Tests
    
    func testBannerItemRowInitialization() {
        // Given
        let item = BannerItem(
            title: "Test Title",
            subtitle: "Test Subtitle",
            iconName: "doc.text",
            hasNavigationArrow: true
        )
        let styleConfig = BannerStyleConfiguration()
        var onTapCalled = false
        let onTap = { onTapCalled = true }
        
        // When
        let view = BannerItemRow(
            item: item,
            styleConfig: styleConfig,
            onTap: onTap
        )
        
        // Then
        XCTAssertEqual(view.item, item)
        
        // Test the view action
        let button = try? view.inspect().find(ViewType.Button.self)
        try? button?.tap()
        XCTAssertTrue(onTapCalled)
    }
    
    // MARK: - PlanSummaryView Tests
    
    func testPlanSummaryViewInitialization() {
        // Given
        let planSummary = PlanSummary.placeholder()
        let styleConfig = BannerStyleConfiguration()
        
        // When
        let view = PlanSummaryView(
            planSummary: planSummary,
            styleConfig: styleConfig
        )
        
        // Then
        // Test if view contains correct content
        let titleText = try? view.inspect().find(ViewType.Text.self, where: { view in
            try view.string() == planSummary.title
        })
        let planNameText = try? view.inspect().find(ViewType.Text.self, where: { view in
            try view.string() == planSummary.planName
        })
        
        XCTAssertNotNil(titleText)
        XCTAssertNotNil(planNameText)
    }
    
    // MARK: - OutOfNetworkView Tests
    
    func testOutOfNetworkViewInitialization() {
        // Given
        let outOfNetworkInfo = OutOfNetworkInfo.placeholder()
        let styleConfig = BannerStyleConfiguration()
        var actionCalled = false
        let action = { actionCalled = true }
        
        // When
        let view = OutOfNetworkView(
            outOfNetworkInfo: outOfNetworkInfo,
            styleConfig: styleConfig,
            action: action
        )
        
        // Then
        // Test if view contains correct content
        let titleText = try? view.inspect().find(ViewType.Text.self, where: { view in
            try view.string() == outOfNetworkInfo.title
        })
        let descriptionText = try? view.inspect().find(ViewType.Text.self, where: { view in
            try view.string() == outOfNetworkInfo.description
        })
        
        XCTAssertNotNil(titleText)
        XCTAssertNotNil(descriptionText)
    }
    
    // MARK: - ActivePlanView Tests
    
    func testActivePlanViewInitialization() {
        // Given
        let activePlanInfo = ActivePlanInfo.placeholder()
        let styleConfig = BannerStyleConfiguration()
        
        // When
        let view = ActivePlanView(
            activePlanInfo: activePlanInfo,
            styleConfig: styleConfig
        )
        
        // Then
        // Test if view contains correct content
        let titleText = try? view.inspect().find(ViewType.Text.self, where: { view in
            try view.string() == activePlanInfo.title
        })
        let subtitleText = try? view.inspect().find(ViewType.Text.self, where: { view in
            try view.string() == activePlanInfo.subtitle
        })
        
        XCTAssertNotNil(titleText)
        XCTAssertNotNil(subtitleText)
    }
    
    // MARK: - CategoryListView Tests
    
    func testCategoryListViewInitialization() {
        // Given
        let instructionText = "Test instruction"
        let items = [
            BannerItem(title: "Item 1", subtitle: "", iconName: "doc.text"),
            BannerItem(title: "Item 2", subtitle: "", iconName: "doc.text")
        ]
        let styleConfig = BannerStyleConfiguration()
        var selectedItem: BannerItem?
        let onItemSelected: (BannerItem) -> Void = { item in
            selectedItem = item
        }
        
        // When
        let view = CategoryListView(
            instructionText: instructionText,
            items: items,
            styleConfig: styleConfig,
            onItemSelected: onItemSelected
        )
        
        // Then
        // Test if view contains correct content
        let instructionTextView = try? view.inspect().find(ViewType.Text.self, where: { view in
            try view.string() == instructionText
        })
        
        XCTAssertNotNil(instructionTextView)
        
        // Test if it has the correct number of rows
        let bannerRows = try? view.inspect().findAll(BannerItemRow.self)
        XCTAssertEqual(bannerRows?.count, 2)
    }
    
    // MARK: - InfoFieldView Tests
    
    func testInfoFieldViewInitialization() {
        // Given
        let label = "Test Label"
        let value = "Test Value"
        let showInfoIcon = true
        let styleConfig = BannerStyleConfiguration()
        
        // When
        let view = InfoFieldView(
            label: label,
            value: value,
            showInfoIcon: showInfoIcon,
            styleConfig: styleConfig
        )
        
        // Then
        // Test if view contains correct content
        let labelText = try? view.inspect().find(ViewType.Text.self, where: { view in
            try view.string() == label
        })
        let valueText = try? view.inspect().find(ViewType.Text.self, where: { view in
            try view.string() == value
        })
        let infoIcon = try? view.inspect().find(ViewType.Image.self)
        
        XCTAssertNotNil(labelText)
        XCTAssertNotNil(valueText)
        XCTAssertNotNil(infoIcon)
    }
    
    // MARK: - MedicalPlanContainerView Tests
    
    func testMedicalPlanContainerViewInitialization() {
        // Given
        let planSummary = PlanSummary.placeholder()
        let outOfNetworkInfo = OutOfNetworkInfo.placeholder()
        let categories = [
            BannerItem(title: "Item 1", subtitle: "", iconName: "doc.text"),
            BannerItem(title: "Item 2", subtitle: "", iconName: "doc.text")
        ]
        
        let planData = MedicalPlanData(
            planSummary: planSummary,
            outOfNetworkInfo: outOfNetworkInfo,
            categories: categories
        )
        
        let styleConfig = BannerStyleConfiguration()
        var selectedCategory: BannerItem?
        let onCategorySelected: (BannerItem) -> Void = { item in
            selectedCategory = item
        }
        
        var outOfNetworkActionCalled = false
        let onOutOfNetworkAction = { outOfNetworkActionCalled = true }
        
        // When
        let view = MedicalPlanContainerView(
            planData: planData,
            styleConfig: styleConfig,
            visibleSections: [.planSummary, .outOfNetwork, .categories],
            onCategorySelected: onCategorySelected,
            onOutOfNetworkAction: onOutOfNetworkAction
        )
        
        // Then
        // Test the view structure
        let planSummaryView = try? view.inspect().find(PlanSummaryView.self)
        let outOfNetworkView = try? view.inspect().find(OutOfNetworkView.self)
        let categoryListView = try? view.inspect().find(CategoryListView.self)
        
        XCTAssertNotNil(planSummaryView)
        XCTAssertNotNil(outOfNetworkView)
        XCTAssertNotNil(categoryListView)
    }
    
    func testMedicalPlanContainerViewWithSelectedSections() {
        // Given
        let planSummary = PlanSummary.placeholder()
        let categories = [
            BannerItem(title: "Item 1", subtitle: "", iconName: "doc.text"),
            BannerItem(title: "Item 2", subtitle: "", iconName: "doc.text")
        ]
        
        let planData = MedicalPlanData(
            planSummary: planSummary,
            outOfNetworkInfo: nil,
            categories: categories
        )
        
        let styleConfig = BannerStyleConfiguration()
        
        // When - Only showing plan summary
        let view1 = MedicalPlanContainerView(
            planData: planData,
            styleConfig: styleConfig,
            visibleSections: [.planSummary]
        )
        
        // Then
        let planSummaryView = try? view1.inspect().find(PlanSummaryView.self)
        let outOfNetworkView = try? view1.inspect().find(OutOfNetworkView.self)
        let categoryListView = try? view1.inspect().find(CategoryListView.self)
        
        XCTAssertNotNil(planSummaryView)
        XCTAssertNil(outOfNetworkView)
        XCTAssertNil(categoryListView)
        
        // When - Only showing categories
        let view2 = MedicalPlanContainerView(
            planData: planData,
            styleConfig: styleConfig,
            visibleSections: [.categories]
        )
        
        // Then
        let planSummaryView2 = try? view2.inspect().find(PlanSummaryView.self)
        let categoryListView2 = try? view2.inspect().find(CategoryListView.self)
        
        XCTAssertNil(planSummaryView2)
        XCTAssertNotNil(categoryListView2)
    }
}

// MARK: - View Modifier Tests

final class ViewModifierTests: XCTestCase {
    
    func testSectionModifier() {
        // Given
        let backgroundColor = Color.red
        let modifier = SectionModifier(backgroundColor: backgroundColor)
        
        // When
        let view = Text("Test").modifier(modifier)
        
        // Then
        let text = try? view.inspect().find(ViewType.Text.self)
        XCTAssertNotNil(text)
        XCTAssertEqual(try? text?.string(), "Test")
        
        // Verify the background color
        let background = try? view.inspect().find(ViewType.ModifiedContent<ViewType.Text, ViewType.StackTransformModifier<ViewType.StackModifier.Padding>>.self)
        XCTAssertNotNil(background)
    }
    
    func testCardModifier() {
        // Given
        let backgroundColor = Color.blue
        let cornerRadius: CGFloat = 12
        let modifier = CardModifier(backgroundColor: backgroundColor, cornerRadius: cornerRadius)
        
        // When
        let view = Text("Test").modifier(modifier)
        
        // Then
        let text = try? view.inspect().find(ViewType.Text.self)
        XCTAssertNotNil(text)
        XCTAssertEqual(try? text?.string(), "Test")
        
        // Verify the background and corner radius
        let background = try? view.inspect().find(ViewType.ModifiedContent<ViewType.Text, ViewType.StackTransformModifier<ViewType.StackModifier.Padding>>.self)
        XCTAssertNotNil(background)
    }
    
    func testViewSectionStyleExtension() {
        // Given
        let config = BannerStyleConfiguration()
        
        // When
        let view = Text("Test").sectionStyle(config)
        
        // Then
        let text = try? view.inspect().find(ViewType.Text.self)
        XCTAssertNotNil(text)
        XCTAssertEqual(try? text?.string(), "Test")
        
        // Verify the section style is applied
        let background = try? view.inspect().find(ViewType.ModifiedContent<ViewType.Text, ViewType.StackTransformModifier<ViewType.StackModifier.Padding>>.self)
        XCTAssertNotNil(background)
    }
    
    func testViewCardStyleExtension() {
        // Given
        let config = BannerStyleConfiguration()
        
        // When
        let view = Text("Test").cardStyle(config)
        
        // Then
        let text = try? view.inspect().find(ViewType.Text.self)
        XCTAssertNotNil(text)
        XCTAssertEqual(try? text?.string(), "Test")
        
        // Verify the card style is applied
        let background = try? view.inspect().find(ViewType.ModifiedContent<ViewType.Text, ViewType.StackTransformModifier<ViewType.StackModifier.Padding>>.self)
        XCTAssertNotNil(background)
    }
    
    func testTextLabelStyleExtension() {
        // Given
        let config = BannerStyleConfiguration()
        
        // When
        let view = Text("Test").labelStyle(config)
        
        // Then
        XCTAssertEqual(try? view.string(), "Test")
        
        // Can't test font and color directly in this unit testing framework
        // but we can verify the text content is preserved
    }
    
    func testTextValueStyleExtension() {
        // Given
        let config = BannerStyleConfiguration()
        
        // When
        let view = Text("Test").valueStyle(config)
        
        // Then
        XCTAssertEqual(try? view.string(), "Test")
        
        // Can't test font and color directly in this unit testing framework
        // but we can verify the text content is preserved
    }
