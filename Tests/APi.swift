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


