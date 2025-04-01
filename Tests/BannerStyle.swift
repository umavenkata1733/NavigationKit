//
//  BannerStyle.swift
//  Reusable
//
//  Created by Anand on 3/30/25.
//

//Banner/Domain/Configuration/BannerStyleConfiguration.swift

import SwiftUI

/// Styling configurations for banner components
///
/// This structure provides a centralized way to configure the visual styling of banners.
/// It follows the Single Responsibility Principle by focusing only on styling concerns.
public struct BannerStyleConfiguration {
    // MARK: - Properties
    
    /// Primary color used for icons and action text
    public let primaryColor: Color
    
    /// Secondary color used for subtitles
    public let secondaryColor: Color
    
    /// Background color for the banner
    public let backgroundColor: Color
    
    /// Corner radius for the banner
    public let cornerRadius: CGFloat
    
    /// Size of the icon
    public let iconSize: CGFloat
    
    /// Whether to show a shadow under the banner
    public let showShadow: Bool
    
    public let arrowIconImageName: String
    
    // MARK: - Initialization
    
    /// Creates a new style configuration with the specified properties
    ///
    /// - Parameters:
    ///   - primaryColor: Primary color for icons and actions
    ///   - secondaryColor: Secondary color for subtitles
    ///   - backgroundColor: Background color
    ///   - cornerRadius: Corner radius
    ///   - iconSize: Size of the icon
    ///   - showShadow: Whether to show a shadow
    public init(
        primaryColor: Color = .blue,
        secondaryColor: Color = .gray,
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 12,
        iconSize: CGFloat = 45,
        showShadow: Bool = true,
        arrowIconImageName: String = "chevron.right"
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.iconSize = iconSize
        self.showShadow = showShadow
        self.arrowIconImageName = arrowIconImageName
    }
    
    /// Default configuration with standard values
    public static var `default`: BannerStyleConfiguration {
        BannerStyleConfiguration()
    }
}


// MARK: - Reusable Banner Component Styles
/// Defines a text style configuration for banner components.
public struct BannerTextStyle {
    public let baseFont: Font
    public let size: Font.Weight
    public let color: Color
    public let padding: EdgePadding
    public let alignment: TextAlignment
    public let scaling: TextScaling
    public let minimumScaleFactor: CGFloat?
    
    /// Initializes a text style with customizable properties.
        /// - Parameters:
        ///   - baseFont: The base font for the text.
        ///   - size: The font weight.
        ///   - color: Text color.
        ///   - padding: Padding around the text using EdgePadding.
        ///   - alignment: Text alignment within the view.
        ///   - scaling: Determines if the text should scale with Dynamic Type settings.
        ///   - minimumScaleFactor: Optional scale factor for text resizing.
    public init(
        baseFont: Font,
        size: Font.Weight = .semibold,
        color: Color,
        padding: EdgePadding = EdgePadding.zero,
        alignment: TextAlignment = .leading,
        scaling: TextScaling = .dynamicType,
        minimumScaleFactor: CGFloat? = 0.8
    ) {
        self.baseFont = baseFont
        self.size = size
        self.color = color
        self.padding = padding
        self.alignment = alignment
        self.scaling = scaling
        self.minimumScaleFactor = minimumScaleFactor
    }
    
    /// Predefined default styles for different banner texts.

    public static let defaultTitle = BannerTextStyle(
        baseFont: .headline,
        size: .semibold,
        color: .primary,
        padding: EdgePadding(bottom: 4),
        scaling: .dynamicType
    )
    
    /// Default subtitle style with dynamic scaling
    public static let defaultSubtitle = BannerTextStyle(
        baseFont: .subheadline,
        size: .regular,
        color: .gray,
        padding: EdgePadding.zero,
        scaling: .dynamicType
    )
    
    /// Default action text style with dynamic scaling
    public static let defaultAction = BannerTextStyle(
        baseFont: .subheadline,
        size: .regular,
        color: .blue,
        padding: EdgePadding(top: 8),
        scaling: .dynamicType
    )
}

/// Style configuration for banner icons, including size, color, and padding.

public struct BannerIconStyle {
    public let size: CGFloat
    public let color: Color
    public let backgroundColor: Color?
    public let padding: EdgePadding
    
    
    /// Initializes an icon style with customizable properties.
       /// - Parameters:
       ///   - size: The size of the icon.
       ///   - color: Icon color.
       ///   - backgroundColor: Optional background color for the icon.
       ///   - padding: Padding around the icon using EdgePadding.
    public init(
        size: CGFloat,
        color: Color,
        backgroundColor: Color? = nil,
        padding: EdgePadding = EdgePadding.zero
    ) {
        self.size = size
        self.color = color
        self.backgroundColor = backgroundColor
        self.padding = padding
    }
    
    /// Default icon style
    public static let `default` = BannerIconStyle(
        size: 40,
        color: .blue,
        backgroundColor: Color.blue.opacity(0.1)
    )
    
    /// List item icon style
    public static let list = BannerIconStyle(
        size: 40,
        color: .blue,
        padding: EdgePadding(leading: 2)
    )
}

// MARK: - Reusable Banner Components

/// A reusable title component for banners.
public struct BannerTitleView: View {
    private let title: String
    private let style: BannerTextStyle
    
    /// Initializes a title view.
    /// - Parameters:
    ///   - title: The text to display.
    ///   - style: Custom style using `BannerTextStyle`. Defaults to `.defaultTitle`.
    public init(title: String, style: BannerTextStyle = .defaultTitle) {
        self.title = title
        self.style = style
    }
    
    public var body: some View {
        Text(title)
            .font(style.baseFont)
            .foregroundColor(style.color)
            .multilineTextAlignment(style.alignment)
            .fixedSize(horizontal: false, vertical: true)
            .padding(style.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .dynamicTypeSize(.medium ... .xxxLarge) // Adjust range as needed
    }
}

/// A reusable subtitle component for banners with dynamic text scaling.
public struct BannerSubtitleView: View {
    private let subtitle: String
    private let style: BannerTextStyle
    
    /// Initializes a subtitle view.
    /// - Parameters:
    ///   - subtitle: The subtitle text.
    ///   - style: Custom style using `BannerTextStyle`. Defaults to `.defaultSubtitle`.
    public init(subtitle: String, style: BannerTextStyle = .defaultSubtitle) {
        self.subtitle = subtitle
        self.style = style
    }
    
    public var body: some View {
        Text(subtitle)
            .font(style.baseFont)
            .foregroundColor(style.color)
            .multilineTextAlignment(style.alignment)
            .fixedSize(horizontal: false, vertical: true)
            .padding(style.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .dynamicTypeSize(.medium ... .xxxLarge) // Adjust range as needed
    }
}

/// A simple reusable component to display action text for banners.
public struct BannerActionTextView: View {
    private let text: String
    private let style: BannerTextStyle
    
    /// Initializes an action text view.
    /// - Parameters:
    ///   - text: The action text.
    ///   - style: Custom style using `BannerTextStyle`. Defaults to `.defaultAction`.
    public init(text: String, style: BannerTextStyle = .defaultAction) {
        self.text = text
        self.style = style
    }
    
    public var body: some View {
        Text(text)
            .font(style.baseFont)
            .foregroundColor(style.color)
            .multilineTextAlignment(style.alignment)
            .padding(style.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .dynamicTypeSize(.medium ... .xxxLarge) // Adjust range as needed
    }
}

/// Reusable icon component for banners
public struct BannerIconView: View {
    private let iconName: String
    private let customImageName: String?
    private let style: BannerIconStyle
    var isDental: Bool
    
    public init(
        iconName: String,
        customImageName: String? = nil,
        style: BannerIconStyle = .default,
        isDental: Bool = false
    ) {
        self.iconName = iconName
        self.customImageName = customImageName
        self.style = style
        self.isDental = isDental
    }
    
    public var body: some View {
        Group {
            
            if isDental {
                Image("dentalChair")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(EdgePadding(top: 8, leading: 8, bottom: 8, trailing: 8))
            } else {
                
                if let imageName = customImageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: style.size, height: style.size)
                } else {
                    if let backgroundColor = style.backgroundColor {
                        ZStack {
                            Circle()
                                .fill(backgroundColor)
                                .frame(width: style.size, height: style.size)
                            
                            Image(systemName: iconName)
                                .font(.system(size: style.size * 0.4))
                                .foregroundColor(style.color)
                        }
                    } else {
                        Image(systemName: "home")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                    }
                }
            }
        }
        .padding(style.padding)
    }
}

/// A flexible view for displaying top banner images with optional fallbacks and customizable styling.
///
/// `BannerTopIconView` attempts to load an image using the provided name. If the image is not available,
/// it gracefully falls back to displaying a gradient background with a default or specified icon.
/// The view supports both fixed height and aspect ratio configurations for responsive layouts.
///
/// - Parameters:
///   - imageName: The name of the image asset to be displayed.
///   - fallbackIconName: The name of the system icon to use as a fallback. Defaults to `"tooth"`.
///   - cornerRadius: The radius of the view's corners. Defaults to `12`.
///   - aspectRatio: Optional aspect ratio to maintain. If `nil`, no aspect ratio is enforced.
///   - fixedHeight: Optional fixed height for the image. If specified, it overrides the aspect ratio.
///
/// Example:
/// ```swift
/// BannerTopIconView(
///     imageName: "dental_banner",
///     fallbackIconName: "tooth",
///     cornerRadius: 16,
///     aspectRatio: 1.5
/// )
/// ```
public struct BannerTopIconView: View {
    // MARK: - Properties
    
    /// The name of the image asset to be displayed.
    private let imageName: String
    
    /// The fallback icon name from SF Symbols, shown if the image cannot be loaded.
    private let fallbackIconName: String
    
    // Image customization options
    /// The corner radius applied to the image view. Defaults to `12`.
    private let cornerRadius: CGFloat
    
    /// The optional aspect ratio for the image. If `nil`, aspect ratio is not applied.
    private let aspectRatio: CGFloat?
    
    /// The optional fixed height for the image. If set, it overrides the aspect ratio.
    private let fixedHeight: CGFloat?
    
    // MARK: - Initialization
    
    /// Creates an instance of `BannerTopIconView`.
    ///
    /// - Parameters:
    ///   - imageName: The name of the image asset.
    ///   - fallbackIconName: Optional system icon to display if the image cannot be loaded.
    ///   - cornerRadius: The corner radius applied to the image.
    ///   - aspectRatio: Aspect ratio to enforce if applicable.
    ///   - fixedHeight: Fixed height of the image. Overrides aspect ratio if set.
    public init(
        imageName: String,
        fallbackIconName: String = "tooth",
        cornerRadius: CGFloat = 12,
        aspectRatio: CGFloat? = nil,
        fixedHeight: CGFloat? = nil
    ) {
        self.imageName = imageName
        self.fallbackIconName = fallbackIconName
        self.cornerRadius = cornerRadius
        self.aspectRatio = aspectRatio
        self.fixedHeight = fixedHeight
    }
    
    // MARK: - Body
    
    /// The body of the view, applying conditional styling based on fixed height or aspect ratio.
    public var body: some View {
        if let height = fixedHeight {
            // Apply a fixed height and corner radius
            imageContent
                .frame(height: height)
                .cornerRadius(cornerRadius)
        } else {
            // Apply an aspect ratio if height is not fixed
            imageContent
                .aspectRatio(aspectRatio, contentMode: .fill)
                .cornerRadius(cornerRadius)
        }
    }
    
    // MARK: - Image Content
    
    /// Provides the image content with graceful fallback to a gradient and icon if the image is unavailable.
    private var imageContent: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = UIImage(named: imageName) {
                    // Render the asset image if available
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    // Fallback gradient with a centered icon
                    LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.7), .blue.opacity(0.4)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay(
                        Image(systemName: fallbackIconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.3)
                    )
                }
            }
            .clipped()
        }
    }
}


/// A reusable view for displaying a top banner with commonly used service buttons.
///
/// `BannerCommonlyUsedView` presents a title, a subtitle, and a grid of service buttons
/// if exactly four services are provided. This layout is commonly used for showing benefit
/// details under a user's plan.
///
/// - Note: This view expects exactly four services for optimal display. Providing fewer
/// or more than four services will not render the buttons correctly.
///
/// - Parameters:
///   - styleConfig: A `BannerStyleConfiguration` containing primary and secondary colors for the view.
///   - services: An array of service names to be displayed as buttons.
///
/// Example:
/// ```swift
/// BannerCommonlyUsedView(
///     styleConfig: BannerStyleConfiguration(primaryColor: .blue, secondaryColor: .gray),
///     services: ["Dental", "Vision", "Medical", "Pharmacy"]
/// )
/// ```
public struct BannerCommonlyUsedView: View {
    // MARK: - Properties
    
    /// Configuration for styling the banner, including colors.
    private let styleConfig: BannerStyleConfiguration
    
    /// Configuration for styling the banner, including colors.
    /// The content and action details for the banner.
    private let item: BannerItem
    
    private let title: String
    
    private let subTitle: String
    
    // Text configurations
    private let titleConfig: AdaptiveTextConfig
    private let subtitleConfig: AdaptiveTextConfig
    private let actionTextConfig: AdaptiveTextConfig

    
    /// Space between the icon and the content, applicable when using left or bottom icon positions.
    private let elementSpacing: CGFloat
    
    /// An array of service names to display as buttons. Requires exactly 4 services.
    var services: [String]
    
    /// Callback handler when a service is tapped.
    private let onServiceTap: (String) -> Void
    
    // MARK: - Initialization
    
    /// Initializes the `BannerCommonlyUsedView` with the specified style configuration and services.
    ///
    /// - Parameters:
    ///   - styleConfig: Configuration for colors and appearance.
    ///   - services: A list of service names, limited to 4 for proper layout.
    public init(
        styleConfig: BannerStyleConfiguration,
        item: BannerItem,
        services: [String],
        elementSpacing: CGFloat = 4,
        title: String,
        subTitle: String,
        // Text configurations with defaults
                titleConfig: AdaptiveTextConfig = .headline,
                subtitleConfig: AdaptiveTextConfig = .subheadline,
                actionTextConfig: AdaptiveTextConfig = .body,
        onServiceTap: @escaping (String) -> Void
    ) {
        self.styleConfig = styleConfig
        self.item = item
        self.services = services
        self.elementSpacing = elementSpacing
        self.title = title
        self.subTitle = subTitle
        self.titleConfig = titleConfig
        self.subtitleConfig = subtitleConfig
        self.actionTextConfig = actionTextConfig
        self.onServiceTap = onServiceTap
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: elementSpacing) {
            // Title
            
            
            //title
            AdaptiveText(title,
                              config: titleConfig,
                              color: .primary)
            
            // Subtitle description
            AdaptiveText(subTitle,
                config: subtitleConfig,
                color: styleConfig.secondaryColor)
            .fixedSize(horizontal: false, vertical: true)
            
            Spacer(minLength: 8)
            
            // Display services if exactly 4 are provided
            if services.count == 4 {
                VStack(spacing: 16) { // Reduced spacing between rows
                    HStack(spacing: 16) {
                        ServiceView(service: services[0], primaryColor: styleConfig.primaryColor, height: 40)
                        ServiceView(service: services[1], primaryColor: styleConfig.primaryColor, height: 40)
                    }
                    
                    HStack(spacing: 16) {
                        ServiceView(service: services[2], primaryColor: styleConfig.primaryColor, height: 40)
                        ServiceView(service: services[3], primaryColor: styleConfig.primaryColor, height: 40)
                    }
                }
            }
        }
    }
}




/// A reusable button component representing a service with a customizable color.
///
/// `ServiceView` provides a stylized button displaying the service name with a primary color.
///
/// - Parameters:
///   - service: The name of the service displayed on the button.
///   - primaryColor: The primary color used for the button's border and text.
///
/// Example:
/// ```swift
/// ServiceView(service: "Support", primaryColor: .blue)
/// ```
public struct ServiceView: View {
    /// The name of the service displayed on the button.
    public let service: String
    
    /// Primary color used for the button's border and text.
    public let primaryColor: Color
    
    /// Height of the button (reduced from default)
    public let buttonHeight: CGFloat
    
    /// Initializes the `ServiceView` with a service name, primary color, and optional height.
    ///
    /// - Parameters:
    ///   - service: The name of the service to be displayed.
    ///   - primaryColor: The primary color used for the button border and text.
    ///   - height: The height of the button (default: 50)
    public init(service: String, primaryColor: Color, height: CGFloat = 50) {
        self.service = service
        self.primaryColor = primaryColor
        self.buttonHeight = height
    }
    
    public var body: some View {
        Button(action: {}) {
            AdaptiveText(service,
                         config: .headline,
                              color: primaryColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8) // Reduced vertical padding
                .frame(minWidth: 60, minHeight: buttonHeight) // Set explicit height
                .foregroundColor(primaryColor)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(primaryColor, lineWidth: 1)
                        )
                )
        }
    }
}

/// A reusable navigation arrow component for banners.
///
/// `BannerNavigationArrowView` displays a system icon, typically used as a navigation indicator, with customizable styling.
///
/// - Parameters:
///   - iconName: The name of the SF Symbol to display. Defaults to `"chevron.right"`.
///   - style: The style configuration for the arrow using `BannerIconStyle`.
///
/// Example:
/// ```swift
/// BannerNavigationArrowView()
/// BannerNavigationArrowView(iconName: "arrow.right", style: BannerIconStyle(size: 20, color: .red))
/// ```
public struct BannerNavigationArrowView: View {
    /// The name of the SF Symbol to display as the navigation icon.
    private let iconName: String
    
    /// The style configuration for the icon, including size, color, and padding.
    private let style: BannerIconStyle
    
    /// Initializes the `BannerNavigationArrowView` with optional parameters.
    ///
    /// - Parameters:
    ///   - iconName: The name of the system icon. Defaults to `"chevron.right"`.
    ///   - style: Customizable icon style using `BannerIconStyle`. Defaults to a blue chevron with size 16.
    public init(
        iconName: String = "chevron.right",
        style: BannerIconStyle = BannerIconStyle(size: 16, color: .blue)
    ) {
        self.iconName = iconName
        self.style = style
    }
    
    public var body: some View {
        Image(systemName: iconName)
            .font(.body)
            .foregroundColor(style.color)
            .padding(style.padding)
    }
}
