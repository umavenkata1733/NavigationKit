//
//  AdaptiveBannerTitleView.swift
//  Reusable
//
//  Created by Anand on 3/30/25.
//

import SwiftUI

// MARK: - Environment Values for Device Detection

/// `HorizontalSizeClassKey` is an `EnvironmentKey` used to store
/// the horizontal size class (`compact` or `regular`) within the SwiftUI environment.
private struct HorizontalSizeClassKey: EnvironmentKey {
    static let defaultValue: UserInterfaceSizeClass? = nil
}

/// `DeviceTypeKey` is an `EnvironmentKey` used to store
/// the type of device (iPhone, iPad, or Mac) within the SwiftUI environment.
private struct DeviceTypeKey: EnvironmentKey {
    static let defaultValue: DeviceType = .iPhone
}

/// Extension on `EnvironmentValues` to provide easy access
/// to the `horizontalSizeClass` and `deviceType` environment properties.
extension EnvironmentValues {
    
    /// Retrieves or sets the horizontal size class (`compact` or `regular`).
    var horizontalSizeClass: UserInterfaceSizeClass? {
        get { self[HorizontalSizeClassKey.self] }
        set { self[HorizontalSizeClassKey.self] = newValue }
    }
    
    /// Retrieves or sets the device type (iPhone, iPad, or Mac).
    var deviceType: DeviceType {
        get { self[DeviceTypeKey.self] }
        set { self[DeviceTypeKey.self] = newValue }
    }
}

/// `DeviceType` enum represents the different device categories.
/// It helps determine appropriate scaling factors for fonts and UI elements.
public enum DeviceType {
    case iPhone, iPad, mac
    
    /// Provides a scale factor based on the device type.
    /// - `iPhone`: 1.0 (default scale)
    /// - `iPad`: 1.2 (slightly larger for better readability)
    /// - `mac`: 1.3 (optimized for macOS)
    var fontScale: CGFloat {
        switch self {
        case .iPhone: return 1.0
        case .iPad: return 1.2
        case .mac: return 1.3
        }
    }
}



// MARK: - Adaptive Text Components

/// A reusable banner title component with adaptive typography.
public struct AdaptiveBannerTitleView: View {
    private let title: String
    private let style: BannerTextStyle
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.deviceType) private var deviceType
    
    /// Initializes the banner title view.
    /// - Parameters:
    ///   - title: The text to display.
    ///   - style: The text style configuration.
    public init(title: String, style: BannerTextStyle = .defaultTitle) {
        self.title = title
        self.style = style
    }
    
    public var body: some View {
        Text(title)
            .font(adaptiveFont())
            .foregroundColor(style.color)
            .multilineTextAlignment(style.alignment)
            .padding(style.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(nil)
            .minimumScaleFactor(style.minimumScaleFactor ?? 1.0)
    }
    
    /// Determines the appropriate font based on scaling preference.
    private func adaptiveFont() -> Font {
        switch style.scaling {
        case .dynamicType:
            return style.baseFont // Automatically scales with system settings
        case .sizeClass:
            return horizontalSizeClass == .regular ? getScaledFont(for: style.baseFont, scaleFactor: 1.3) : style.baseFont
        case .deviceSpecific:
            return style.baseFont
        }
    }
}

/// A reusable banner subtitle component with adaptive typography.
public struct AdaptiveBannerSubtitleView: View {
    private let subtitle: String
    private let style: BannerTextStyle
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.deviceType) private var deviceType
    
    /// Initializes the banner subtitle view.
    /// - Parameters:
    ///   - subtitle: The text to display.
    ///   - style: The text style configuration.
    public init(subtitle: String, style: BannerTextStyle = .defaultSubtitle) {
        self.subtitle = subtitle
        self.style = style
    }
    
    public var body: some View {
        Text(subtitle)
            .font(adaptiveFont())
            .foregroundColor(style.color)
            .multilineTextAlignment(style.alignment)
            .fixedSize(horizontal: false, vertical: true)
            .padding(style.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(nil)
            .minimumScaleFactor(style.minimumScaleFactor ?? 1.0)
    }
    
    /// Determines the appropriate font based on scaling preference.
    private func adaptiveFont() -> Font {
        switch style.scaling {
        case .dynamicType:
            return style.baseFont
        case .sizeClass:
            return horizontalSizeClass == .regular ? getScaledFont(for: style.baseFont, scaleFactor: 1.3) : style.baseFont
        case .deviceSpecific:
            return style.baseFont
        }
    }
}

/// A reusable banner action text component with adaptive typography.
public struct AdaptiveBannerActionTextView: View {
    private let text: String
    private let style: BannerTextStyle
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.deviceType) private var deviceType
    
    /// Initializes the banner action text view.
    /// - Parameters:
    ///   - text: The text to display.
    ///   - style: The text style configuration.
    public init(text: String, style: BannerTextStyle = .defaultAction) {
        self.text = text
        self.style = style
    }
    
    public var body: some View {
        Text(text)
            .font(adaptiveFont())
            .foregroundColor(style.color)
            .multilineTextAlignment(style.alignment)
            .padding(style.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(nil)
            .minimumScaleFactor(style.minimumScaleFactor ?? 1.0)
    }
    
    /// Determines the appropriate font based on scaling preference.
    private func adaptiveFont() -> Font {
        switch style.scaling {
        case .dynamicType:
            return style.baseFont
        case .sizeClass:
            return horizontalSizeClass == .regular ? getScaledFont(for: style.baseFont, scaleFactor: 1.3) : style.baseFont
        case .deviceSpecific:
            return style.baseFont
        }
    }
}

/// Helper function to adjust font size based on a scaling factor.
private func getScaledFont(for font: Font, scaleFactor: CGFloat) -> Font {
    switch font {
    case .largeTitle: return .system(size: 34 * scaleFactor)
    case .title: return .system(size: 28 * scaleFactor)
    case .title2: return .system(size: 22 * scaleFactor)
    case .title3: return .system(size: 20 * scaleFactor)
    case .headline: return .system(size: 17 * scaleFactor, weight: .semibold)
    case .body: return .system(size: 17 * scaleFactor)
    case .callout: return .system(size: 16 * scaleFactor)
    case .subheadline: return .system(size: 15 * scaleFactor)
    case .footnote: return .system(size: 13 * scaleFactor)
    case .caption: return .system(size: 12 * scaleFactor)
    case .caption2: return .system(size: 11 * scaleFactor)
    default: return .system(size: 17 * scaleFactor)
    }
}
