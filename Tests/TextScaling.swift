//
//  TextScaling.swift
//  Reusable
//
//  Created by Anand on 3/30/25.
//

import SwiftUI

// MARK: - Adaptive Text Style Configuration

/// A flexible text scaling configuration that adjusts font size and style based on various factors.
/// This enum supports dynamic adjustments to ensure readability across different devices and accessibility settings.
public enum TextScaling {
    
    /// Adjusts text using SwiftUI's Dynamic Type, ensuring compatibility with system-wide accessibility settings.
    case dynamicType
    
    /// Uses predefined font sizes specific to different device categories, such as iPhones or iPads.
    case deviceSpecific
    
    /// Adjusts font size based on the horizontal size class of the device (e.g., compact for iPhones, regular for iPads).
    case sizeClass
    
    // MARK: - Equatability
    
    /// Compares two `TextScaling` configurations to determine if they are equivalent.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `TextScaling` to compare.
    ///   - rhs: The right-hand side `TextScaling` to compare.
    /// - Returns: `true` if both configurations are equivalent; otherwise, `false`.
    public static func == (lhs: TextScaling, rhs: TextScaling) -> Bool {
        switch (lhs, rhs) {
        case (.dynamicType, .dynamicType),
             (.deviceSpecific, .deviceSpecific),
             (.sizeClass, .sizeClass):
            return true
        default:
            return false
        }
    }
}

// MARK: - Conformance

/// Makes `TextScaling` conform to `Equatable` to support comparisons.
extension TextScaling: Equatable {}
