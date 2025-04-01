//
//  WellnessBannerView.swift
//  Reusable
//
//  Created by Anand on 3/30/25.
//
import SwiftUI

import SwiftUI

/// A customizable banner view used to display wellness content with a title, subtitle, and an optional action button.
/// This view supports configurable styling and padding, making it suitable for various use cases in health and wellness applications.
public struct WellnessBannerView: View {
    // MARK: - Properties
    
    /// The content and action details for the banner.
    private let item: BannerItem
    
    /// Configuration for the banner's style including colors, corner radius, and shadow.
    private let styleConfig: BannerStyleConfiguration
    
    // Container padding
    private let containerPadding: EdgePadding
    private let contentPadding: EdgePadding
    
    
    // Text configurations
    private let titleConfig: AdaptiveTextConfig
    private let subtitleConfig: AdaptiveTextConfig
    private let actionTextConfig: AdaptiveTextConfig
    
    // Component styles
    private let titleStyle: BannerTextStyle
    private let subtitleStyle: BannerTextStyle
    private let actionTextStyle: BannerTextStyle
    
    // Layout spacing
    private let contentSpacing: CGFloat
    
    /// Action to be performed when the banner is tapped.
    private let onTap: (BannerItem) -> Void
    
    // MARK: - Initialization
    /// Creates a new `WellnessBannerView` with customizable styles, paddings, and content.
    /// This initializer allows flexibility by providing optional custom styles and layout adjustments.
    ///
    /// - Parameters:
    ///   - item: The `BannerItem` containing the banner's content.
    ///   - styleConfig: A `BannerStyleConfiguration` for customizing the appearance.
    ///   - containerPadding: Outer padding around the banner. Default is horizontal padding of 10 points.
    ///   - contentPadding: Inner padding around the content. Default is 16 points on all sides.
    ///   - titleStyle: Optional `BannerTextStyle` to customize the title text.
    ///   - subtitleStyle: Optional `BannerTextStyle` to customize the subtitle text.
    ///   - actionTextStyle: Optional `BannerTextStyle` to customize the action text.
    ///   - contentSpacing: Spacing between the title, subtitle, and action text. Default is 4 points.
    ///   - onTap: Closure triggered when the banner is tapped, passing the `BannerItem`.
    public init(
        item: BannerItem,
        styleConfig: BannerStyleConfiguration = .default,
        
        // Container padding
        containerPadding: EdgePadding = EdgePadding(horizontal: 10),
        contentPadding: EdgePadding = EdgePadding(all: 16),
        // Text configurations with defaults
                titleConfig: AdaptiveTextConfig = .headline,
                subtitleConfig: AdaptiveTextConfig = .subheadline,
                actionTextConfig: AdaptiveTextConfig = .body,
        
        // Component styles
        titleStyle: BannerTextStyle? = nil,
        subtitleStyle: BannerTextStyle? = nil,
        actionTextStyle: BannerTextStyle? = nil,

        // Layout spacing
        contentSpacing: CGFloat = 4,
        
        onTap: @escaping (BannerItem) -> Void
    ) {
        self.item = item
        self.styleConfig = styleConfig
        
        self.containerPadding = containerPadding
        self.contentPadding = contentPadding
        
        self.titleConfig = titleConfig
        self.subtitleConfig = subtitleConfig
        self.actionTextConfig = actionTextConfig
        
        
        // Apply default styles if needed
        self.titleStyle = titleStyle ?? BannerTextStyle(
            baseFont: .headline.weight(.semibold),
            size: .semibold,
            color: .primary,
            padding: EdgePadding(bottom: 4)
        )
        
        self.subtitleStyle = subtitleStyle ?? BannerTextStyle(
            baseFont: .subheadline,
            size: .regular,
            color: styleConfig.secondaryColor,
            padding: EdgePadding(bottom: 4)
        )
        
        self.actionTextStyle = actionTextStyle ?? BannerTextStyle(
            baseFont: .headline.weight(.medium),
            size: .regular,
            color: styleConfig.primaryColor,
            padding: EdgePadding(top: 4)
        )
        
        self.contentSpacing = contentSpacing
        
        self.onTap = onTap
    }
    
    // MARK: - Body
    /// The main view structure displaying the banner's content with optional background image and shadow.
    public var body: some View {
        Button(action: { onTap(item) }) {
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: styleConfig.cornerRadius)
                    .fill(styleConfig.backgroundColor)
                
                // Meditation Image as Background
                if let meditationImage = UIImage(named: "mediatation_icon") {
                    Image(uiImage: meditationImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .opacity(0.1)
                        .offset(x: 180, y: 10)
                }
                
                // Content section
                VStack(alignment: .leading, spacing: contentSpacing) {
                    
                    //title
                    AdaptiveText(item.title,
                                      config: titleConfig,
                                      color: .primary)
           
                    // Subtitle description
                    AdaptiveText(item.subtitle,
                        config: subtitleConfig,
                        color: styleConfig.secondaryColor)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    // Action button
                    if let actionText = item.actionText {
                         AdaptiveBannerActionTextView(
                            text: actionText,
                            style: actionTextStyle
                        )
                    }
                }
                .padding(contentPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .cornerRadius(styleConfig.cornerRadius)
            .shadow(radius: styleConfig.showShadow ? 2 : 0)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(containerPadding)
    }
}
