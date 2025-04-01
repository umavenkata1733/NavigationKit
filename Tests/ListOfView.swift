//
//  ListOfView.swift
//  Reusable
//
//  Created by Anand on 3/31/25.
//

import SwiftUI

// MARK: - Improved Banner Display Logic

/// Configuration for banner display
struct BannerDisplayConfig {
    // Banner IDs to display (if empty, will display all unless excluded)
    var includeIDs: Set<String> = []
    
    // Banner IDs to exclude
    var excludeIDs: Set<String> = []
    
    // Group banners by display style
    var groupByDisplayStyle: Bool = false
    
    // Default styling for different banner types
    var defaultStyles: [BannerType: BannerStyleConfig] = [:]
    
    // Default banner type mapping
    var typeMapping: [String: BannerType] = [
        "mentalHealth": .wellness,
        "dentalBenefits": .dental,
        "commonly_Used" : .commonlyUsed,
        "medical_plan_123": .underStandYourPlan
        
    ]
    
    // Add to BannerDisplayConfig
    var displayOrder: [BannerType] = [
        .standard,          // Then standard banners
        .underStandYourPlan, // Then plan info
        .commonlyUsed,      // Show commonly used first
        .wellness,          // Then wellness
        .dental,            // Then dental
        .list,   // Lists at the end
        .goPaper             // Then cards
    ]
    
    /// Determines if a banner should be displayed
    func shouldDisplay(banner: BannerItem) -> Bool {
        // If include list is not empty, only show banners in the list
        if !includeIDs.isEmpty {
            return includeIDs.contains(banner.id)
        }
        
        // Otherwise show all banners except those in exclude list
        return !excludeIDs.contains(banner.id)
    }
    
    /// Determines the appropriate banner type
    func getBannerType(for banner: BannerItem) -> BannerType {
        // Check for explicit mapping first
        if let mappedType = typeMapping[banner.id] {
            return mappedType
        }
        
        // Otherwise determine based on display style
        switch banner.displayStyle {
        case .list:
            return .list
        case .card:
            return .goPaper
        default:
            return .standard
        }
    }
}

/// Configuration for styling different types of banners.
/// Provides customizable options for text styles, padding, and background appearance.
struct BannerStyleConfig {

    /// Style configuration for the title text, including font, color, and optional padding.
    var titleStyle: BannerTextStyle?

    /// Style configuration for the subtitle text, including font, color, and optional padding.
    var subtitleStyle: BannerTextStyle?

    /// Style configuration for the action text (e.g., call-to-action), including font, color, and optional padding.
    var actionTextStyle: BannerTextStyle?

    /// Padding applied outside the banner to create spacing from surrounding views.
    var containerPadding: EdgePadding?

    /// Padding applied within the banner to control spacing around its content.
    var contentPadding: EdgePadding?
    
    // MARK: - Additional Configuration

    /// Optional name of the image to be displayed in the corner of the banner.
    var cornerImageName: String?
    
    /// Background color for circular elements, applicable to certain banner designs.
    var backgroundCircleColor: Color?
}




// MARK: - Banner Manager View
/// A view that manages and displays banners using a given configuration and view model.
/// Supports both flat and grouped display styles.
struct BannerManagerView: View {
    /// ViewModel managing the state and data for banners.
    @StateObject private var viewModel: BannerViewModel
    
    /// Configuration for how banners should be displayed.
    let displayConfig: BannerDisplayConfig
    
    /// Initializes the BannerManagerView with an optional ViewModel and display configuration.
    /// - Parameters:
    ///   - viewModel: Optional custom view model. Defaults to a factory-generated instance.
    ///   - displayConfig: Configuration for display options. Defaults to a standard configuration.

    init(viewModel: BannerViewModel? = nil,
         displayConfig: BannerDisplayConfig = BannerDisplayConfig()) {
        if let vm = viewModel {
            self._viewModel = StateObject(wrappedValue: vm)
        } else {
            let factory = BannerFactory.shared
            self._viewModel = StateObject(wrappedValue: factory.makeBannerViewModel())
        }
        
        self.displayConfig = displayConfig
    }
    
    /// The body of the view, displaying banners using the configured style.
    var body: some View {
        VStack(spacing: 16) {
            // Get filtered banners
            let filteredBanners = viewModel.banners.filter { displayConfig.shouldDisplay(banner: $0) }
            
            // Group banners by their type
            let bannersByType = Dictionary(grouping: filteredBanners) { banner in
                displayConfig.getBannerType(for: banner)
            }
            
            // Display banners in the specified order
            ForEach(displayConfig.displayOrder, id: \.self) { bannerType in
                if let bannersOfType = bannersByType[bannerType] {
                    // Special handling for list-type banners
                    if bannerType == .list && !bannersOfType.isEmpty {
                        Text("Find Cost for Care Services")
                            .font(.headline)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 0) {
                            ForEach(bannersOfType) { banner in
                                renderBanner(banner)
                                
                                if banner.id != bannersOfType.last?.id {
                                    Divider()
                                        .background(Color(.systemGray5))
                                        .padding(.leading, 10)
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    } else {
                        // Standard rendering for other banner types
                        ForEach(bannersOfType) { banner in
                            renderBanner(banner)
                        }
                    }
                }
            }
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
    }
        
    
    /// Renders a specific banner using its corresponding view and configuration.
    /// - Parameter banner: The banner item to be displayed.
    @ViewBuilder
    private func renderBanner(_ banner: BannerItem) -> some View {
        let bannerType = displayConfig.getBannerType(for: banner)
        let defaultStyle = displayConfig.defaultStyles[bannerType]
        
        switch bannerType {
        case .standard:
            BannerView(
                item: banner,
                styleConfig: .default,
                iconPosition: .left,
                containerPadding: defaultStyle?.containerPadding ?? EdgePadding(horizontal: 16), contentPadding: defaultStyle?.contentPadding ?? EdgePadding(all: 16), titleStyle: defaultStyle?.titleStyle ?? BannerTextStyle(
                    baseFont: .headline.bold(),
                    color: .primary,
                    padding: EdgePadding(bottom: 8),
                    scaling: .dynamicType
                ),
                subtitleStyle: defaultStyle?.subtitleStyle ?? BannerTextStyle(
                    baseFont: .subheadline,
                    color: .secondary,
                    padding: EdgePadding(bottom: 4),
                    scaling: .dynamicType
                ),
                actionTextStyle: defaultStyle?.actionTextStyle,
                onTap: { item in
                    print("Banner tapped: \(item.id)")
                }
            )
            
        case .wellness:
            WellnessBannerView(
                item: banner,
                styleConfig: .default,
                containerPadding: defaultStyle?.containerPadding ?? EdgePadding(horizontal: 16), contentPadding: defaultStyle?.contentPadding ?? EdgePadding(all: 16), titleStyle: defaultStyle?.titleStyle ?? BannerTextStyle(
                    baseFont: .headline.bold(),
                    color: .primary,
                    padding: EdgePadding(bottom: 8),
                    scaling: .dynamicType
                ),
                subtitleStyle: defaultStyle?.subtitleStyle ?? BannerTextStyle(
                    baseFont: .subheadline,
                    color: .secondary,
                    padding: EdgePadding(bottom: 4),
                    scaling: .dynamicType
                ),
                actionTextStyle: defaultStyle?.actionTextStyle,
                onTap: { item in
                    print("WellnessBannerView tapped: \(item.id)")
                }
            )
                
            
        case .dental:
            
            BannerView(
                item: banner,
                styleConfig: .default,
                iconPosition: .dental,
                containerPadding: defaultStyle?.containerPadding ?? EdgePadding(horizontal: 16), contentPadding: defaultStyle?.contentPadding ?? EdgePadding(all: 16), titleStyle: defaultStyle?.titleStyle ?? BannerTextStyle(
                    baseFont: .headline.bold(),
                    color: .primary,
                    padding: EdgePadding(bottom: 8),
                    scaling: .dynamicType
                ),
                subtitleStyle: defaultStyle?.subtitleStyle ?? BannerTextStyle(
                    baseFont: .subheadline,
                    color: .secondary,
                    padding: EdgePadding(bottom: 4),
                    scaling: .dynamicType
                ),
                actionTextStyle: defaultStyle?.actionTextStyle,
                onTap: { item in
                    print("dental tapped: \(item.id)")
                }
            )
            
        case .list:
            BannerView(
                item: banner,
                styleConfig: BannerStyleConfiguration(
                    primaryColor: .blue,
                    secondaryColor: .gray,
                    backgroundColor: .white,
                    cornerRadius: 0,
                    iconSize: 30,
                    showShadow: false
                ),
                containerPadding: EdgePadding.zero,
                contentPadding: EdgePadding(all: 16),
                titleStyle: defaultStyle?.titleStyle ?? BannerTextStyle(
                    baseFont: .headline,
                    color: .primary,
                    padding: EdgePadding(bottom: 4),
                    scaling: .dynamicType
                ),
                onTap: { item in
                    print("\(item.title) tapped: \(item.id)")
                }
            )
            
        case .goPaper:
            BannerView(
                item: banner,
                styleConfig: .default,
                containerPadding: defaultStyle?.containerPadding ?? EdgePadding(horizontal: 16),
                contentPadding: defaultStyle?.contentPadding ?? EdgePadding(all: 16)) {  item in
                    print("Go paper less tapped: \(item.id)")
                }
        case .commonlyUsed:
            BannerView(
                item: banner,
                styleConfig: .default,
                iconPosition: .commonlyUsed,
                containerPadding: defaultStyle?.containerPadding ?? EdgePadding(horizontal: 16), contentPadding: defaultStyle?.contentPadding ?? EdgePadding(all: 16), titleStyle: defaultStyle?.titleStyle ?? BannerTextStyle(
                    baseFont: .headline.bold(),
                    color: .primary,
                    padding: EdgePadding(bottom: 8),
                    scaling: .dynamicType
                ),
                subtitleStyle: defaultStyle?.subtitleStyle ?? BannerTextStyle(
                    baseFont: .subheadline,
                    color: .secondary,
                    padding: EdgePadding(bottom: 4),
                    scaling: .dynamicType
                ),
                actionTextStyle: defaultStyle?.actionTextStyle,
                onTap: { item in
                    print("Banner tapped: \(item.id)")
                }
            )
        case .underStandYourPlan:
            if let plan = PlanDataProvider.loadMedicalPlanFromString() {
                MedicalPlanView(plan: plan)
            }
        }
    }
}
