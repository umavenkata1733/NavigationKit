//
//  BannerContentView.swift
//  Reusable
//
//  Created by Anand on 3/30/25.
//
import SwiftUI

/// A reusable content view for displaying banner items using configurable styles and adaptive text components.
///
/// `BannerContentView` is designed to display a banner with a title, subtitle, and optional action text.
/// It also supports the inclusion of a navigation arrow for actionable banners. The component applies adaptive styles
/// and ensures dynamic type scaling for accessibility.
///
/// - Parameters:
///   - item: The `BannerItem` containing the title, subtitle, optional action text, and navigation arrow flag.
///   - styleConfig: The `BannerStyleConfiguration` containing primary and secondary colors and icon configurations.
///   - titleConfig: Configuration for the adaptive title text using `AdaptiveTextConfig`. Defaults to `.headline`.
///   - subtitleConfig: Configuration for the adaptive subtitle text using `AdaptiveTextConfig`. Defaults to `.subheadline`.
///   - actionTextConfig: Configuration for the adaptive action text using `AdaptiveTextConfig`. Defaults to `.body`.
///   - titleStyle: Optional custom style for the title using `BannerTextStyle`.
///   - subtitleStyle: Optional custom style for the subtitle using `BannerTextStyle`.
///   - actionTextStyle: Optional custom style for the action text using `BannerTextStyle`.
///   - navigationArrowStyle: Optional style for the navigation arrow using `BannerIconStyle`.
///   - rowSpacing: Vertical spacing between rows. Defaults to `4` points.
///
/// Example usage:
/// ```swift
/// BannerContentView(
///     item: bannerItem,
///     styleConfig: bannerStyleConfig
/// )
/// 
public struct BannerContentView: View {
    private let item: BannerItem
    private let styleConfig: BannerStyleConfiguration
    
    // Component styles
    private let titleStyle: BannerTextStyle
    private let subtitleStyle: BannerTextStyle
    private let actionTextStyle: BannerTextStyle
    private let navigationArrowStyle: BannerIconStyle
    
    // Text configurations
    private let titleConfig: AdaptiveTextConfig
    private let subtitleConfig: AdaptiveTextConfig
    private let actionTextConfig: AdaptiveTextConfig
    
    // Layout configuration
    private let rowSpacing: CGFloat
    
    /// Initializes a `BannerContentView` with customizable configurations for title, subtitle, action text, and navigation arrow display.
    ///
    /// - Parameters:
    ///   - item: A `BannerItem` representing the content of the banner, including title, subtitle, action text, and navigation arrow flag.
    ///   - styleConfig: A `BannerStyleConfiguration` providing primary and secondary colors, as well as arrow icon details.
    ///   - titleConfig: An `AdaptiveTextConfig` to configure the appearance of the title text, supporting adaptive font scaling. Defaults to `.headline`.
    ///   - subtitleConfig: An `AdaptiveTextConfig` to configure the appearance of the subtitle text. Defaults to `.subheadline`.
    ///   - actionTextConfig: An `AdaptiveTextConfig` for configuring the action text. Defaults to `.body`.
    ///   - titleStyle: An optional `BannerTextStyle` for customizing the appearance of the title, including font, color, padding, and scaling.
    ///   - subtitleStyle: An optional `BannerTextStyle` for customizing the appearance of the subtitle. Defaults to a regular subheadline with adaptive scaling.
    ///   - actionTextStyle: An optional `BannerTextStyle` for customizing the action text style. Defaults to subheadline with primary color.
    ///   - navigationArrowStyle: An optional `BannerIconStyle` for configuring the appearance of the navigation arrow, including size, color, and padding.
    ///   - rowSpacing: A `CGFloat` representing the vertical spacing between rows of text. Defaults to `4`.
    ///
    /// Example:
    /// ```swift
    /// BannerContentView(
    ///     item: BannerItem(
    ///         title: "Welcome Back!",
    ///         subtitle: "Check out the latest updates.",
    ///         actionText: "Learn More",
    ///         hasNavigationArrow: true
    ///     ),
    ///     styleConfig: BannerStyleConfiguration(
    ///         primaryColor: .blue,
    ///         secondaryColor: .gray,
    ///         arrowIconImageName: "chevron.right"
    ///     ),
    ///     rowSpacing: 8
    /// )
    /// ```
    public init(
        item: BannerItem,
        styleConfig: BannerStyleConfiguration,
        
        // Text configurations with defaults
                titleConfig: AdaptiveTextConfig = .headline,
                subtitleConfig: AdaptiveTextConfig = .subheadline,
                actionTextConfig: AdaptiveTextConfig = .body,
        
        // Component styles with reasonable defaults
        titleStyle: BannerTextStyle? = nil,
        subtitleStyle: BannerTextStyle? = nil,
        actionTextStyle: BannerTextStyle? = nil,
        navigationArrowStyle: BannerIconStyle? = nil,
        // Layout configuration
        rowSpacing: CGFloat = 4
    ) {
        self.item = item
        self.styleConfig = styleConfig
        
        // Apply default styles if needed
        self.titleStyle = titleStyle ?? BannerTextStyle(
            baseFont: .headline,
            size: .semibold,
            color: .primary,
            padding: EdgePadding(bottom: 4),
            scaling: .dynamicType
        )
        
        self.titleConfig = titleConfig
              self.subtitleConfig = subtitleConfig
              self.actionTextConfig = actionTextConfig
        
        self.subtitleStyle = subtitleStyle ?? BannerTextStyle(
            baseFont: .subheadline,
            size: .regular,
            color: styleConfig.secondaryColor,
            padding: EdgePadding.zero,
            scaling: .dynamicType
        )
        
        self.actionTextStyle = actionTextStyle ?? BannerTextStyle(
            baseFont: .headline,
            size: .semibold,
            color: .primary,
            padding: EdgePadding.zero,
            scaling: .dynamicType
        )
        
        self.navigationArrowStyle = navigationArrowStyle ?? BannerIconStyle(
            size: 16,
            color: styleConfig.primaryColor,
            padding: EdgePadding.zero
        )
        
        self.rowSpacing = rowSpacing
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: rowSpacing) {
            // Title row with optional navigation arrow
            HStack(alignment: .top, spacing: 4) {
                // Adaptive text for title
                AdaptiveText(item.title,
                             config: titleConfig,
                             color: .primary)
                Spacer(minLength: 8)
                
                // Show navigation arrow if specified
                if item.hasNavigationArrow {
                    BannerNavigationArrowView(
                        iconName: styleConfig.arrowIconImageName,
                        style: navigationArrowStyle
                    )
                }
            }
            // Adaptive text for subtitle
            AdaptiveText(
                item.subtitle,
                config: subtitleConfig,
                color: styleConfig.secondaryColor
            )
            .fixedSize(horizontal: false, vertical: true)
            
            // Optional action text
            if let actionText = item.actionText {
                AdaptiveBannerActionTextView(
                    text: actionText,
                    style: actionTextStyle
                )
            }
        }
        .adaptToDevice() // Apply device detection for adaptive scaling
    }
}
