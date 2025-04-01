//
//  BannerType.swift
//  Reusable
//
//  Created by Anand on 4/1/25.
//


import SwiftUI

/// Represents the different types of banners supported by `UnifiedBannerView`.
/// Each banner type has a distinct design and layout optimized for specific use cases.
enum BannerType {
    
    /// A standard banner with a title, subtitle, and optional action text.
    case standard
    
    /// A wellness-focused banner designed to promote health-related information or services.
    case wellness
    
    /// A dental-specific banner, typically used for displaying dental care information.
    case dental
    
    /// A list-style banner that can display multiple items, often used for overviews or summaries.
    case list
    
    /// A card-style banner that emphasizes visual content, often resembling a card layout.
    case goPaper
    
    /// A banner displaying frequently accessed or commonly used services with distinct sections.
    case commonlyUsed
    
    /// A banner displaying frequently accessed or commonly used services with distinct sections.
    case underStandYourPlan
}
