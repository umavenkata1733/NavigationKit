//
//  BannerEdgePadding.swift
//  Reusable
//
//  Created by Anand on 3/30/25.
//
import SwiftUI

// MARK: - EdgePadding

/// A configurable structure representing padding for all sides of a view.
///
/// `EdgePadding` allows defining padding values for each edge individually (top, leading, bottom, and trailing).
/// It also provides convenient initializers for applying uniform padding or horizontal and vertical padding.
///
/// Example usage:
/// ```swift
/// let padding = EdgePadding(top: 10, leading: 12, bottom: 10, trailing: 12)
/// let uniformPadding = EdgePadding(all: 16)
/// let horizontalVerticalPadding = EdgePadding(horizontal: 20, vertical: 10)
/// ```
///
/// - Parameters:
///   - top: Padding applied to the top edge.
///   - leading: Padding applied to the leading edge.
///   - bottom: Padding applied to the bottom edge.
///   - trailing: Padding applied to the trailing edge.
public struct EdgePadding {
    
    // MARK: - Properties
    
    /// Padding value for the top edge.
    public let top: CGFloat
    
    /// Padding value for the leading edge (left in LTR, right in RTL).
    public let leading: CGFloat
    
    /// Padding value for the bottom edge.
    public let bottom: CGFloat
    
    /// Padding value for the trailing edge (right in LTR, left in RTL).
    public let trailing: CGFloat
    
    // MARK: - Initializers
    
    /// Initializes `EdgePadding` with custom values for each edge.
    ///
    /// - Parameters:
    ///   - top: Padding for the top edge. Defaults to `0`.
    ///   - leading: Padding for the leading edge. Defaults to `0`.
    ///   - bottom: Padding for the bottom edge. Defaults to `0`.
    ///   - trailing: Padding for the trailing edge. Defaults to `0`.
    public init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }
    
    /// Initializes `EdgePadding` with uniform padding applied to all edges.
    ///
    /// - Parameter all: Padding applied equally to top, leading, bottom, and trailing edges.
    public init(all: CGFloat) {
        self.top = all
        self.leading = all
        self.bottom = all
        self.trailing = all
    }
    
    /// Initializes `EdgePadding` with separate horizontal and vertical values.
    ///
    /// - Parameters:
    ///   - horizontal: Padding applied to leading and trailing edges. Defaults to `0`.
    ///   - vertical: Padding applied to top and bottom edges. Defaults to `0`.
    public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.top = vertical
        self.leading = horizontal
        self.bottom = vertical
        self.trailing = horizontal
    }
    
    // MARK: - Preset Padding Values
    
    /// A preset with no padding on any side.
    public static let zero = EdgePadding(all: 0)
    
    /// A standard padding value commonly used in UI designs.
    public static let standard = EdgePadding(all: 16)
}

// MARK: - View Extension

/// An extension to apply `EdgePadding` to any SwiftUI `View`.
extension View {
    
    /// Applies the specified `EdgePadding` to the view.
    ///
    /// This extension simplifies the process of adding individual edge paddings by using `EdgePadding`.
    ///
    /// Example:
    /// ```swift
    /// Text("Hello, World!")
    ///     .padding(EdgePadding(horizontal: 16, vertical: 8))
    /// ```
    ///
    /// - Parameter edgePadding: The padding values to apply to the view.
    /// - Returns: A view with the specified padding applied to all sides.
    func padding(_ edgePadding: EdgePadding) -> some View {
        self.padding(.top, edgePadding.top)
            .padding(.leading, edgePadding.leading)
            .padding(.bottom, edgePadding.bottom)
            .padding(.trailing, edgePadding.trailing)
    }
}
