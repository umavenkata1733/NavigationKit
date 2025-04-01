//
//  IconViewFactory.swift
//  Reusable
//
//  Created by Anand on 3/30/25.
//

import SwiftUI

// MARK: - View Modifiers

/// A view modifier that applies styling to banners using a provided configuration.
///
/// This modifier is useful for maintaining consistent banner appearance across the app.
///
/// Example usage:
/// ```swift
/// Text("Hello, Banner!")
///     .modifier(BannerViewStyle(styleConfig: myBannerStyleConfig))
/// ```
///
/// - Note: This modifier uses a `BannerStyleConfiguration` to apply background color, corner radius,
/// and optional shadow effects.
public struct BannerViewStyle: ViewModifier {
    
    /// The configuration defining the appearance of the banner.
    private let styleConfig: BannerStyleConfiguration
    
    /// Initializes the `BannerViewStyle` with a given style configuration.
    /// - Parameter styleConfig: The configuration that defines the visual appearance of the banner.
    public init(styleConfig: BannerStyleConfiguration) {
        self.styleConfig = styleConfig
    }
    
    /// Applies the banner style to the given content.
    ///
    /// - Parameter content: The content to which the banner style will be applied.
    /// - Returns: A view with the applied banner style, including background color, corner radius, and shadow.
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(styleConfig.backgroundColor)
            .cornerRadius(styleConfig.cornerRadius)
            .shadow(radius: styleConfig.showShadow ? 2 : 0)
    }
}


// MARK: - View Extensions

extension View {
    public func bannerStyle(_ styleConfig: BannerStyleConfiguration) -> some View {
        self.modifier(BannerViewStyle(styleConfig: styleConfig))
    }
}

// MARK: - Icon Layout Views

/// A layout component that arranges an icon to the left of its content.
///
/// This view is useful for creating banner layouts or any UI that requires a left-aligned icon
/// with descriptive content next to it.
///
/// Example usage:
/// ```swift
/// LeftIconLayout(
///     icon: Image(systemName: "star.fill").foregroundColor(.yellow),
///     content: Text("This is a featured item.")
///         .font(.headline),
///     contentPadding: EdgePadding(horizontal: 16, vertical: 8),
///     spacing: 12
/// )
/// ```
///
/// - Parameters:
///   - Icon: A view representing the icon. Usually an `Image` or a custom icon view.
///   - Content: A view representing the descriptive content, typically `Text`.
///   - contentPadding: The padding to apply around the content and icon using `EdgePadding`.
///   - spacing: The spacing between the icon and the content.
struct LeftIconLayout<Icon: View, Content: View>: View {
    
    /// The icon view displayed on the left side.
    let icon: Icon
    
    /// The content view displayed on the right side of the icon.
    let content: Content
    
    /// The padding applied around the entire layout using `EdgePadding`.
    let contentPadding: EdgePadding
    
    /// The spacing between the icon and the content view.
    let spacing: CGFloat
    
    /// The body of the view, arranging the icon and content horizontally.
    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            icon
            content
        }
        .padding(contentPadding)
    }
}



/// A layout component that arranges an icon below its content.
///
/// This view is useful for creating banners or card layouts where an icon is positioned
/// at the bottom, aligned to the leading edge of the content.
///
/// Example usage:
/// ```swift
/// BottomIconLayout(
///     icon: Image(systemName: "checkmark.circle.fill").foregroundColor(.green),
///     content: Text("Task Completed Successfully!")
///         .font(.headline),
///     contentPadding: EdgePadding(horizontal: 16, vertical: 8),
///     spacing: 12
/// )
/// ```
///
/// - Parameters:
///   - Icon: A view representing the icon. Usually an `Image` or a custom icon view.
///   - Content: A view representing the descriptive content, typically `Text`.
///   - contentPadding: The padding to apply around the content and icon using `EdgePadding`.
///   - spacing: The spacing between the content and the icon.
struct BottomIconLayout<Icon: View, Content: View>: View {
    
    /// The icon view displayed below the content.
    let icon: Icon
    
    /// The content view displayed above the icon.
    let content: Content
    
    /// The padding applied around the entire layout using `EdgePadding`.
    let contentPadding: EdgePadding
    
    /// The spacing between the content and the icon view.
    let spacing: CGFloat
    
    /// The body of the view, arranging the content above the icon vertically.
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            content
            icon
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(contentPadding)
    }
}

/// A layout component that displays content without an icon.
///
/// This view is useful for displaying text or other views in a clean, minimal layout
/// when no icon is needed. It applies padding around the content using `EdgePadding`.
///
/// Example usage:
/// ```swift
/// NoIconLayout(
///     content: Text("Welcome to our service!")
///         .font(.headline)
///         .foregroundColor(.primary),
///     contentPadding: EdgePadding(horizontal: 16, vertical: 8)
/// )
/// ```
///
/// - Parameters:
///   - Content: The view representing the content to display. Typically a `Text` or a combination of views.
///   - contentPadding: The padding to apply around the content using `EdgePadding`.
struct NoIconLayout<Content: View>: View {
    
    /// The content view to display within the layout.
    let content: Content
    
    /// The padding applied around the content using `EdgePadding`.
    let contentPadding: EdgePadding
    
    /// The body of the view, applying padding to the content.
    var body: some View {
        content
            .padding(contentPadding)
    }
}


// MARK: - Icon Factory

/// A factory responsible for creating customizable icon views for banners.
///
/// The `IconViewFactory` generates icons using a provided `BannerStyleConfiguration`.
/// It supports system icons, custom images, and different styles based on the banner's display type.
/// Icons are rendered within a styled view, optionally wrapped in a circular background for emphasis.
///
/// Example usage:
/// ```swift
/// let factory = IconViewFactory(styleConfig: bannerStyleConfig)
/// let iconView = factory.createIconView(for: bannerItem, customImageName: "customIcon")
/// ```
///
/// - Note: The size, color, and padding of icons are determined using `BannerStyleConfiguration`.
public struct IconViewFactory {
    
    /// The style configuration determining icon appearance.
    private let styleConfig: BannerStyleConfiguration
    
    /// Initializes the factory with a specific style configuration.
    ///
    /// - Parameter styleConfig: The configuration used for icon appearance and sizing.
    public init(styleConfig: BannerStyleConfiguration) {
        self.styleConfig = styleConfig
    }
    
    /// Creates an icon view using the provided item and optional image.
    ///
    /// This method generates the appropriate icon based on the banner's `displayStyle`.
    /// - If a `customImageName` is provided, it uses that image.
    /// - For `.list` style banners, a simple system icon is applied.
    /// - For other styles, the icon is displayed within a circular background.
    ///
    /// - Parameters:
    ///   - item: The `BannerItem` containing the icon information.
    ///   - customImageName: An optional name of a custom image to display instead of the system icon.
    ///   - padding: Optional padding applied around the icon using `EdgePadding`. Defaults to `.zero`.
    ///
    /// - Returns: A SwiftUI view representing the rendered icon.
    public func createIconView(for item: BannerItem,
                                customImageName: String? = nil,
                                padding: EdgePadding = .zero) -> some View {
        
        let iconContent: AnyView
        
        if let imageName = customImageName {
            // Render a custom image if provided
            iconContent = AnyView(
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: styleConfig.iconSize, height: styleConfig.iconSize)
                    .padding(padding)
            )
        } else if item.displayStyle == .list {
            // Render a system icon for list-style banners
            iconContent = AnyView(
                Image(systemName: item.iconName ?? "")
                    .font(.title2)
                    .foregroundColor(styleConfig.primaryColor)
                    .frame(width: 30, height: 30)
                    .padding(padding)
            )
        } else {
            // Render a circular icon for other banner styles
            iconContent = AnyView(
                ZStack {
                    Circle()
                        .fill(styleConfig.primaryColor.opacity(0.1))
                        .frame(width: styleConfig.iconSize, height: styleConfig.iconSize)
                    
                    Image(systemName: item.iconName ?? "")
                        .font(.system(size: styleConfig.iconSize * 0.4))
                        .foregroundColor(styleConfig.primaryColor)
                }
                .padding(padding)
            )
        }
        
        return iconContent
    }
}
