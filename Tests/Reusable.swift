//
//  Reusable.swift
//  Reusable
//
//  Created by Anand on 3/30/25.
//

//contentPadding, containerPadding
import SwiftUI

// MARK: - Main Banner View Using Reusable Components
/// A versatile banner view that supports customizable content, layout, and icon positioning.
/// Provides flexibility using reusable components and adaptive configurations.
public struct BannerView: View {
    
    // MARK: - Icon Position Enum
    /// Enum representing the different positions for displaying an icon within the banner.
    public enum IconPosition {
        case left       /// Icon displayed to the left of the content.
        case bottom     /// Icon displayed below the content.
        case none       /// No icon displayed.
        case dental     /// Displays a dental-specific icon with custom layout.
        case commonlyUsed /// Displays a common services view with a divider.
    }
    
    // MARK: - Properties
        /// Banner content including title, subtitle, and action text.
        private let item: BannerItem
        
        /// Configuration for the banner's appearance, including colors, corner radius, and shadow.
        private let styleConfig: BannerStyleConfiguration
        
        /// The position of the icon within the banner.
        let iconPosition: IconPosition
        
        /// Optional custom image name for the icon.
        private let customImageName: String?
        
        // Padding Configurations
        /// Padding applied outside the banner to provide spacing from other elements.
        private let containerPadding: EdgePadding
        
        /// Padding applied within the banner to adjust the space around its content.
        private let contentPadding: EdgePadding
        
        /// Space between the icon and the content, applicable when using left or bottom icon positions.
        private let elementSpacing: CGFloat
        
        // Component Styles
        /// Style configuration for the title text, controlling font, color, and padding.
        private let titleStyle: BannerTextStyle
        
        /// Style configuration for the subtitle text, controlling font, color, and padding.
        private let subtitleStyle: BannerTextStyle
        
        /// Style configuration for the action text, typically used for interactive call-to-actions.
        private let actionTextStyle: BannerTextStyle
        
        /// Style configuration for the banner's icon, controlling size, color, and background.
        private let iconStyle: BannerIconStyle
        
        /// Style configuration for the navigation arrow icon, if applicable.
        private let navigationArrowStyle: BannerIconStyle
        
        /// Vertical spacing between content rows.
        private let rowSpacing: CGFloat
        
        /// Closure triggered when the banner is tapped.
        private let onTap: (BannerItem) -> Void
        
        // MARK: - Initialization
        /// Initializes a new `BannerView` with customizable options.
        ///
        /// - Parameters:
        ///   - item: The `BannerItem` containing title, subtitle, and action text.
        ///   - styleConfig: Configuration for banner appearance (default: `.default`).
        ///   - iconPosition: Position of the icon (.left, .bottom, .none, .dental, .commonlyUsed).
        ///   - customImageName: Optional custom image for the icon.
        ///   - containerPadding: Padding applied outside the banner.
        ///   - contentPadding: Padding applied inside the banner.
        ///   - elementSpacing: Space between icon and content.
        ///   - titleStyle: Style for title text.
        ///   - subtitleStyle: Style for subtitle text.
        ///   - actionTextStyle: Style for action text.
        ///   - iconStyle: Style for icon.
        ///   - navigationArrowStyle: Style for navigation arrow.
        ///   - rowSpacing: Space between content rows.
        ///   - onTap: Closure called when the banner is tapped.
    public init(
        item: BannerItem,
        styleConfig: BannerStyleConfiguration = .default,
        iconPosition: IconPosition = .left,
        customImageName: String? = nil,
        
        // Container padding configurations
        containerPadding: EdgePadding = EdgePadding(horizontal: 10),
        contentPadding: EdgePadding = EdgePadding(all: 16),
        elementSpacing: CGFloat = 16,
        
        // Component styles
        titleStyle: BannerTextStyle? = nil,
        subtitleStyle: BannerTextStyle? = nil,
        actionTextStyle: BannerTextStyle? = nil,
        iconStyle: BannerIconStyle? = nil,
        navigationArrowStyle: BannerIconStyle? = nil,
        
        // Layout spacing
        rowSpacing: CGFloat = 8,
        
        onTap: @escaping (BannerItem) -> Void
    ) {
        self.item = item
        self.styleConfig = styleConfig
        self.iconPosition = iconPosition
        self.customImageName = customImageName
        
        self.containerPadding = containerPadding
        self.contentPadding = contentPadding
        self.elementSpacing = elementSpacing
        
        // Apply default styles if needed
        self.titleStyle = titleStyle ?? BannerTextStyle(
            baseFont: .headline,
            color: .primary,
            padding: EdgePadding(bottom: 4)
        )
        
        self.subtitleStyle = subtitleStyle ?? BannerTextStyle(
            baseFont: .subheadline,
            color: styleConfig.secondaryColor,
            padding: EdgePadding.zero
        )
        
        self.actionTextStyle = actionTextStyle ?? BannerTextStyle(
            baseFont: .subheadline,
            color: styleConfig.primaryColor,
            padding: EdgePadding(top: 8)
        )
        
        self.iconStyle = iconStyle ?? BannerIconStyle(
            size: styleConfig.iconSize,
            color: styleConfig.primaryColor,
            backgroundColor: styleConfig.primaryColor.opacity(0.1)
        )
        
        self.navigationArrowStyle = navigationArrowStyle ?? BannerIconStyle(
            size: 16,
            color: styleConfig.primaryColor,
            padding: EdgePadding.zero
        )
        
        self.rowSpacing = rowSpacing
        
        self.onTap = onTap
    }
    
    // MARK: - Body
    /// The primary view displaying the banner's layout and content based on the specified configuration.
    public var body: some View {
        Button(action: { onTap(item) }) {
            // Create content view with reusable components
            let contentView = BannerContentView(
                item: item,
                styleConfig: styleConfig,
                titleConfig: AdaptiveTextConfig(
                    baseFontStyle: .headline,
                    weight: .bold,
                    iphoneSize: 17,   // Size on iPhone
                    ipadSize: 22,     // Size on iPad
                    macSize: 24,      // Size on Mac
                    sizingStrategy: .deviceSpecific
                ),
                subtitleConfig: AdaptiveTextConfig(
                    baseFontStyle: .body,
                    weight: .regular,
                    iphoneSize: 15,   // Size on iPhone
                    ipadSize: 18,     // Size on iPad
                    macSize: 20,      // Size on Mac
                    sizingStrategy: .deviceSpecific
                ),
                actionTextConfig: AdaptiveTextConfig(
                    baseFontStyle: .body,
                    weight: .regular,
                    iphoneSize: 15,   // Size on iPhone
                    ipadSize: 18,     // Size on iPad
                    macSize: 20,      // Size on Mac
                    sizingStrategy: .deviceSpecific
                ),
                titleStyle: titleStyle,
                subtitleStyle: subtitleStyle,
                actionTextStyle: actionTextStyle,
                navigationArrowStyle: navigationArrowStyle,
                rowSpacing: rowSpacing
            )
            
            
            // Create icon with reusable component
            let iconView = BannerIconView(
                iconName: item.iconName ?? "",
                customImageName: customImageName,
                style: iconStyle
            )
            
            // Create icon with reusable component
            let iconViewDental = BannerTopIconView(imageName: "dentalChair",
                                                   fixedHeight: 150)
                .padding(EdgePadding(all: 16))
            
            
            // Create commonly used services section using the BannerCommonlyUsedView component
              let commonlyUsedView = BannerCommonlyUsedView(
                styleConfig: styleConfig,
                item: item,
                services: [
                    "Virtual Care", "Preventive Care",
                    "Emergency Care", "Urgent Care"
                ],
                elementSpacing: 4, title: "Commonly Used Services",
                subTitle: "Review benefit details for commonly used services covered under your plan.") { serviceName in
                              print("tapped \(serviceName)")
                          }
                .padding(EdgePadding(bottom: 10))
            
            // Apply appropriate layout based on icon position
            Group {
                switch iconPosition {
                case .left:
                    HStack(alignment: .top, spacing: elementSpacing) {
                        iconView
                        contentView
                    }
                    .padding(contentPadding)
                
                case .bottom:
                    VStack(alignment: .leading, spacing: elementSpacing) {
                            contentView
                            iconView
                                .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(contentPadding)
                    
                case .none:
                    HStack(alignment: .top, spacing: elementSpacing) {
                        contentView
                    }
                    .padding(contentPadding)
                    
                case .dental:
                    VStack(alignment: .center) {
                        iconViewDental
                        HStack(alignment: .top, spacing: elementSpacing) {
                            iconView
                            contentView
                        }
                        .padding(contentPadding)
                    }
                case .commonlyUsed:
                    VStack(alignment: .leading, spacing: elementSpacing) {
                        HStack(alignment: .top, spacing: elementSpacing) {
                            iconView
                            contentView
                        }
                        .padding(EdgePadding(top: 16, leading: 16, bottom: 0,trailing: 16))
                        Divider()
                            .background(Color(.systemGray5))
                            .padding(.leading, 10)
                        commonlyUsedView
                            .padding(EdgePadding(top: 0, leading: 16, bottom: 8,trailing: 16))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(styleConfig.backgroundColor)
            .cornerRadius(styleConfig.cornerRadius)
            .shadow(radius: styleConfig.showShadow ? 2 : 0)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(containerPadding)
    }
}

