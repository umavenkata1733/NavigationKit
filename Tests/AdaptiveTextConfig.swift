import SwiftUI

/// Configuration for text that automatically adapts to different devices and size classes
public struct AdaptiveTextConfig {
    /// The base text style from SwiftUI's built-in text styles (e.g., .body, .headline)
    /// This provides a foundation for the text appearance
    public let baseFontStyle: Font.TextStyle
    
    /// The font weight (e.g., .regular, .bold, .semibold) to control text thickness
    public let weight: Font.Weight
    
    /// Optional font design (e.g., .serif, .rounded) for typographic styling
    /// When nil, the system default design is used
    public let design: Font.Design?
    
    /// The base font size in points for iPhone devices
    /// Used as the foundation size when calculating the actual displayed text size
    public let iphoneSize: CGFloat
    
    /// The base font size in points for iPad devices
    /// Typically larger than iPhone size for better readability on larger screens
    public let ipadSize: CGFloat
    
    /// The base font size in points for macOS devices
    /// Typically the largest size to accommodate viewing distance on desktop
    public let macSize: CGFloat
    
    /// Size multiplier applied when horizontal size class is compact
    /// Values less than 1.0 reduce text size, greater than 1.0 increase it
    public let compactSizeFactor: CGFloat
    
    /// Size multiplier applied when horizontal size class is regular
    /// Typically larger than compactSizeFactor to utilize additional screen space
    public let regularSizeFactor: CGFloat
    
    /// The smallest allowable scale factor for the text
    /// Prevents text from becoming unreadably small when constrained
    public let minimumScaleFactor: CGFloat
    
    /// Optional limit on the number of text lines to display
    /// When nil, text can use as many lines as needed
    public let lineLimit: Int?
    
    /// Strategy determining how text scaling is applied:
    /// - deviceSpecific: Uses device-specific sizes (iPhone/iPad/Mac)
    /// - dynamicType: Respects user's accessibility settings
    /// - fixed: Uses exact specified sizes regardless of context
    public let sizingStrategy: TextScaling
    
    /// Creates a configuration with customizable text appearance parameters
    /// - Parameters:
    ///   - baseFontStyle: The SwiftUI font style to base on
    ///   - weight: The font weight for emphasis control
    ///   - design: Optional font design style
    ///   - iphoneSize: Base font size for iPhones
    ///   - ipadSize: Base font size for iPads
    ///   - macSize: Base font size for Mac devices
    ///   - compactSizeFactor: Size multiplier for compact width environments
    ///   - regularSizeFactor: Size multiplier for regular width environments
    ///   - minimumScaleFactor: Smallest allowable text scale when constrained
    ///   - lineLimit: Maximum number of lines to display
    ///   - sizingStrategy: How text sizing should be calculated
    public init(
        baseFontStyle: Font.TextStyle = .body,
        weight: Font.Weight = .regular,
        design: Font.Design? = nil,
        iphoneSize: CGFloat = 17,
        ipadSize: CGFloat = 20,
        macSize: CGFloat = 22,
        compactSizeFactor: CGFloat = 1.0,
        regularSizeFactor: CGFloat = 1.2,
        minimumScaleFactor: CGFloat = 0.75,
        lineLimit: Int? = nil,
        sizingStrategy: TextScaling = .deviceSpecific
    ) {
        // Initialize properties with provided values
        self.baseFontStyle = baseFontStyle
        self.weight = weight
        self.design = design
        self.iphoneSize = iphoneSize
        self.ipadSize = ipadSize
        self.macSize = macSize
        self.compactSizeFactor = compactSizeFactor
        self.regularSizeFactor = regularSizeFactor
        self.minimumScaleFactor = minimumScaleFactor
        self.lineLimit = lineLimit
        self.sizingStrategy = sizingStrategy
    }
    
    /// Predefined configuration for large, prominent title text
    /// Optimized for headings and major section titles
    public static let title = AdaptiveTextConfig(
        baseFontStyle: .title,
        weight: .bold,
        iphoneSize: 22,
        ipadSize: 28,
        macSize: 32
    )
    
    /// Predefined configuration for headline text
    /// Suitable for section headers and emphasized content
    public static let headline = AdaptiveTextConfig(
        baseFontStyle: .headline,
        weight: .semibold,
        iphoneSize: 17,
        ipadSize: 20,
        macSize: 22
    )
    
    /// Predefined configuration for body text
    /// Designed for the main content text with optimal readability
    public static let body = AdaptiveTextConfig(
        baseFontStyle: .body,
        weight: .regular,
        iphoneSize: 16,
        ipadSize: 18,
        macSize: 20
    )
    
    /// Predefined configuration for subheadline text
    /// Smaller than body text but still easily readable for secondary information
    public static let subheadline = AdaptiveTextConfig(
        baseFontStyle: .subheadline,
        weight: .regular,
        iphoneSize: 15,
        ipadSize: 17,
        macSize: 18
    )
    
    /// Predefined configuration for caption text
    /// Smallest comfortable reading size for supplementary information
    public static let caption = AdaptiveTextConfig(
        baseFontStyle: .caption,
        weight: .regular,
        iphoneSize: 12,
        ipadSize: 14,
        macSize: 15
    )
}
