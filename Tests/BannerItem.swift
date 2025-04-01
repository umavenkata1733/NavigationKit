//
//  BannerItem.swift
//  Reusable
//
//  Created by Anand on 3/30/25.
//

//Banner/Domain/Entities/BannerItem.swift

import SwiftUI

/// Domain entity representing a banner item in the application
///
/// This is the core business model that represents a banner as it's used in the application.
public struct BannerItem: Identifiable, Equatable {
    // MARK: - Properties
    
    /// Unique identifier for the banner
    public let id: String
    
    /// Main title text of the banner
    public let title: String
    
    /// Supporting subtitle text or description
    public let subtitle: String
    
    /// SF Symbol name for the banner's icon
    public let iconName: String?
    
    /// Optional call-to-action text
    public let actionText: String?
    
    /// Whether the banner should display a navigation arrow
    public let hasNavigationArrow: Bool
    
    /// Visual style of the banner
    public let displayStyle: DisplayStyle
    
    /// Optional navigation route identifier
    public let route: String?
    
    // MARK: - Nested Types
    
    /// Visual style options for banners
    public enum DisplayStyle: String, Codable, Equatable {
        /// Full-width welcome/featured banner
        case banner
        
        /// Compact list item
        case list
        
        /// Card-style item with more visual prominence
        case card
    }
    
    // MARK: - Initialization
    
    /// Creates a new banner item with the specified properties
    ///
    /// - Parameters:
    ///   - id: Unique identifier
    ///   - title: Main title text
    ///   - subtitle: Supporting text or description
    ///   - iconName: SF Symbol name for the icon
    ///   - actionText: Optional call-to-action text
    ///   - hasNavigationArrow: Whether to show a navigation arrow
    ///   - displayStyle: Visual style (banner, list, or card)
    ///   - route: Optional navigation route identifier
    public init(
        id: String,
        title: String,
        subtitle: String,
        iconName: String,
        actionText: String? = nil,
        hasNavigationArrow: Bool = false,
        displayStyle: DisplayStyle = .banner,
        route: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.actionText = actionText
        self.hasNavigationArrow = hasNavigationArrow
        self.displayStyle = displayStyle
        self.route = route
    }
}
