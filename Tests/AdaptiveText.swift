//
//  AdaptiveText.swift
//  Reusable
//
//  Created by Anand on 3/31/25.
//

import SwiftUI

// A SwiftUI text view that adapts to different devices and user settings
public struct AdaptiveText: View {
    // The text content to display
    private let text: String
    // Configuration defining font size, weight, and scaling strategy
    private let config: AdaptiveTextConfig
    // Text color
    private let color: Color
    // Text alignment
    private let alignment: TextAlignment
    
    // Environment values for adaptive behavior based on device traits
    @Environment(\ .horizontalSizeClass) private var horizontalSizeClass
    @Environment(\ .verticalSizeClass) private var verticalSizeClass
    @Environment(\ .dynamicTypeSize) private var dynamicTypeSize
    
    /// Initializes the adaptive text view with given properties
    /// - Parameters:
    ///   - text: The text to display
    ///   - config: Configuration specifying font styles and scaling behavior (default: .body)
    ///   - color: Text color (default: .primary)
    ///   - alignment: Text alignment (default: .leading)
    public init(
        _ text: String,
        config: AdaptiveTextConfig = .body,
        color: Color = .primary,
        alignment: TextAlignment = .leading
    ) {
        self.text = text
        self.config = config
        self.color = color
        self.alignment = alignment
    }
    
    public var body: some View {
        Text(text)
            .font(getAdaptiveFont())
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
            .lineLimit(config.lineLimit)
            .minimumScaleFactor(config.minimumScaleFactor)
    }
    
    /// Determines the appropriate font style based on the selected sizing strategy
    private func getAdaptiveFont() -> Font {
        switch config.sizingStrategy {
        case .dynamicType:
            return getBaseDynamicFont() // Uses system Dynamic Type settings for accessibility
        case .deviceSpecific:
            return getDeviceSpecificFont() // Uses predefined sizes for each device type
        case .sizeClass:
            return getSizeClassBasedFont() // Adjusts size based on size class (compact/regular)
        }
    }
    
    /// Returns a dynamic type font that adapts to user accessibility settings
    private func getBaseDynamicFont() -> Font {
        var font = Font.system(config.baseFontStyle, design: config.design)
        font = font.weight(config.weight)
        return font
    }
    
    /// Returns a font with predefined sizes for different device types
    private func getDeviceSpecificFont() -> Font {
        let size: CGFloat
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            size = config.iphoneSize
        case .pad:
            size = config.ipadSize
        case .mac:
            size = config.macSize
        default:
            size = config.iphoneSize
        }
        
        return Font.system(size: size, weight: config.weight, design: config.design)
    }
    
    /// Returns a font that scales based on the device's size class (compact or regular)
    private func getSizeClassBasedFont() -> Font {
        let scaleFactor = horizontalSizeClass == .regular ? config.regularSizeFactor : config.compactSizeFactor
        
        return .system(
            size: getSizeForCurrentDevice() * scaleFactor,
            weight: config.weight,
            design: config.design
        )
    }
    
    /// Returns a font that scales based on the screen width
    private func getScreenWidthBasedFont() -> Font {
        let screenWidth = UIScreen.main.bounds.width
        
        // Calculate scale factor based on a base width of 375 (iPhone 8/SE2)
        let scaleFactor = screenWidth / 375.0
        let adjustedSize = config.iphoneSize * min(scaleFactor, 1.5) // Capped at 1.5x scaling
        
        return .system(
            size: adjustedSize,
            weight: config.weight,
            design: config.design
        )
    }
    
    /// Retrieves the base font size for the current device type
    private func getSizeForCurrentDevice() -> CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: return config.iphoneSize
        case .pad: return config.ipadSize
        case .mac: return config.macSize
        default: return config.iphoneSize
        }
    }
}

// MARK: - Extensions for SwiftUI Text

extension Text {
    /// Applies an adaptive font configuration to a text view
    /// - Parameter config: Configuration specifying font properties
    /// - Returns: A text view with adaptive font scaling applied
    public func adaptiveFont(_ config: AdaptiveTextConfig) -> some View {
        self.modifier(AdaptiveFontModifier(config: config))
    }
}

/// A modifier that applies adaptive font sizing based on device and size class
struct AdaptiveFontModifier: ViewModifier {
    let config: AdaptiveTextConfig
    
    @Environment(\ .horizontalSizeClass) private var horizontalSizeClass
    
    func body(content: Content) -> some View {
        let fontSize: CGFloat
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            fontSize = config.iphoneSize
        case .pad:
            fontSize = config.ipadSize
        case .mac:
            fontSize = config.macSize
        default:
            fontSize = config.iphoneSize
        }
        
        // Adjust font size based on size class if using size class strategy
        let adjustedSize = config.sizingStrategy == .sizeClass && horizontalSizeClass == .regular
            ? fontSize * config.regularSizeFactor
            : fontSize
        
        return content
            .font(.system(size: adjustedSize, weight: config.weight, design: config.design))
            .lineLimit(config.lineLimit)
            .minimumScaleFactor(config.minimumScaleFactor)
    }
}
