import SwiftUI

// MARK: - Banner Views

/// Reusable banner component for displaying a single banner item
///
/// This component is responsible for rendering a single banner with configurable styling.
/// It follows the Single Responsibility Principle by focusing only on rendering one banner item.
public struct BannerView: View {
    
    // MARK: - Properties
    
    /// The banner item to display
    private let item: BannerItem
    
    /// Style configuration for the banner
    private let styleConfig: BannerStyleConfiguration
    
    /// Action to perform when the banner is tapped
    private let onTap: (BannerItem) -> Void
    
    public let imageName: String? // For local images or illustrations

    
    // MARK: - Initialization
    
    /// Creates a new banner view
    ///
    /// - Parameters:
    ///   - item: The banner item to display
    ///   - styleConfig: Style configuration (optional, defaults to standard styling)
    ///   - onTap: Action to perform when the banner is tapped
    public init(
        item: BannerItem,
        styleConfig: BannerStyleConfiguration = .default,
        imageName: String? = nil,
        onTap: @escaping (BannerItem) -> Void
    ) {
        self.item = item
        self.styleConfig = styleConfig
        self.onTap = onTap
        self.imageName = imageName
    }
    
    // MARK: - Computed Properties
    
    /// Whether the banner should use list-style layout
    private var isListStyle: Bool {
        return item.displayStyle == .list
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: { onTap(item) }) {
            HStack(alignment: .top, spacing: 16) {
                // Icon with appropriate styling based on display style
                // Then update the BannerView to display the image if provided:
                // Inside BannerView's body, replace or supplement the icon section:
//               if isListStyle {
//                    Image(systemName: item.iconName)
//                        .font(.title2)
//                        .foregroundColor(styleConfig.primaryColor)
//                        .frame(width: 30, height: 30)
//                } else {
                    ZStack {
                        Circle()
                            .fill(styleConfig.primaryColor.opacity(0.1))
                            .frame(width: styleConfig.iconSize, height: styleConfig.iconSize)
                        
                        Image(systemName: item.iconName)
                            .font(.system(size: styleConfig.iconSize * 0.4))
                            .foregroundColor(styleConfig.primaryColor)
                    }
               // }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top, spacing: 4) {
                        Text(item.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        
                        // Chevron if needed
                        if item.hasNavigationArrow {
                            Image(systemName: styleConfig.arrowIconImageName)
                                .foregroundColor(styleConfig.primaryColor)
                                .font(.body)
                        }
                    }
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundColor(styleConfig.secondaryColor)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if let actionText = item.actionText {
                        Text(actionText)
                            .font(.subheadline)
                            .foregroundColor(styleConfig.primaryColor)
                            .padding(.top, 4)
                    }
                }
                
               
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(styleConfig.backgroundColor)
            .cornerRadius(styleConfig.cornerRadius)
            .shadow(radius: !isListStyle ? 2 : 0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


import SwiftUI
import Combine


// MARK: - Updated Integration Example

struct CleanBannerIntegrationExample: View {
    @StateObject private var viewModel: BannerViewModel
    
    init() {
        let factory = BannerFactory.shared
        _viewModel = StateObject(wrappedValue: factory.makeBannerViewModel())
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Banner
                    if let welcomeBanner = viewModel.getBanners(ofStyle: .banner).first {
                        BannerView(
                            item: welcomeBanner,
                            styleConfig: BannerStyleConfiguration(
                                primaryColor: .blue,
                                secondaryColor: .gray,
                                backgroundColor: .white,
                                cornerRadius: 16
                            )
                        ) { item in
                            print("Welcome banner tapped: \(item.id)")
                        }
                        .padding(.horizontal)
                    }
                    
                    // Cost Estimator items (just Medical and Drug Cost) with separator line
                    let costEstimators = viewModel.banners.filter {
                        $0.id == "medical-cost" || $0.id == "drug-cost"
                    }
                    
                    if !costEstimators.isEmpty {
                        VStack(spacing: 0) {
                            Text("Find Cost for Care Services")
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 8)
                            
                            VStack(spacing: 0) {
                                // First item (Medical Cost)
                                
                                if let medicalCost = costEstimators.first(where: { $0.id == "medical-cost" }) {
                                    BannerView(
                                        item: medicalCost,
                                        styleConfig: BannerStyleConfiguration(
                                            primaryColor: .blue,
                                            secondaryColor: .gray,
                                            backgroundColor: .white,
                                            cornerRadius: 16
                                        )
                                    ) { item in
                                        print("Welcome banner tapped: \(item.id)")
                                    }
                                }
                                
                                // Separator line
                                Divider()
                                    .background(Color(.systemGray5))
                                    .padding(.leading, 66) // Align with content, not icon
                                
                                // Second item (Drug Cost)
                                if let drugCost = costEstimators.first(where: { $0.id == "drug-cost" }) {
                                    BannerView(
                                        item: drugCost,
                                        styleConfig: BannerStyleConfiguration(
                                            primaryColor: .blue,
                                            secondaryColor: .gray,
                                            backgroundColor: .white,
                                            cornerRadius: 16
                                        )
                                    ) { item in
                                        print("Welcome banner tapped: \(item.id)")
                                    }
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal)
                    }
                    
                    // ID Card as a separate banner (like welcome banner)
                    if let idCard = viewModel.banners.first(where: { $0.id == "idCard" }) {
                        BannerView(
                            item: idCard,
                            styleConfig: BannerStyleConfiguration(
                                primaryColor: .blue,
                                secondaryColor: .gray,
                                backgroundColor: .white,
                                cornerRadius: 16
                            )
                        ) { item in
                            print("ID Card tapped: \(item.id)")
                        }
                        .padding(.horizontal)
                    }
                    
                    // Card Style Banners
                    let cardBanners = viewModel.getBanners(ofStyle: .card)
                    if !cardBanners.isEmpty {
                        VStack(alignment: .leading, spacing: 5) {
//                            Text("Features")
//                                .font(.title3)
//                                .fontWeight(.bold)
//                                .padding(.horizontal)
                            
                            ForEach(cardBanners) { item in
                                BannerFactory.shared.makeBannerView(
                                    item: item,
                                    styleConfig: BannerStyleConfiguration(
                                        primaryColor: .blue,
                                        secondaryColor: .gray,
                                        cornerRadius: 16,
                                        iconSize: 45
                                    )
                                ) { item in
                                    print("Card banner tapped: \(item.id)")
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
                .background(Color(.systemGray6))
            }
            .navigationTitle("Banner")
            .onAppear {
                loadSampleData()
            }
        }
    }
    
    private func loadSampleData() {
        let jsonString = """
        [
            {
                "id": "welcome",
                "title": "Welcome to your new plan",
                "displayStyle": "banner",
                "hasNavigationArrow": true,
                "elements": {
                    "description": {
                        "value": "See what's staying the same and what's changing."
                    },
                    "icon": {
                        "value": "umbrella.fill"
                    }
                }
            },
            {
                "id": "medical-cost",
                "title": "Medical Cost Estimator",
                "displayStyle": "list",
                "hasNavigationArrow": true,
                "elements": {
                    "description": {
                        "value": "Get a cost estimate for medical services."
                    },
                    "icon": {
                        "value": "doc.text.fill"
                    }
                }
            },
            {
                "id": "drug-cost",
                "title": "Drug Cost Estimator",
                "displayStyle": "list",
                "hasNavigationArrow": true,
                "elements": {
                    "description": {
                        "value": "Get a drug cost estimate."
                    },
                    "icon": {
                        "value": "pill.fill"
                    }
                }
            },
            {
                "id": "idCard",
                "title": "Id Card Help",
                "displayStyle": "banner",
                "hasNavigationArrow": true,
                "elements": {
                    "description": {
                        "value": "Order member ID cards"
                    },
                    "icon": {
                        "value": "creditcard.fill"
                    }
                }
            },
            {
                "id": "premium",
                "title": "Get paperless billing",
                "displayStyle": "card",
                "actionText": "Go Paperless",
                "elements": {
                    "description": {
                        "value": "Manage your health plan and billing documents electronically."
                    },
                    "icon": {
                        "value": "leaf"
                    }
                }
            }
        ]
        """
        viewModel.loadFromJSONString(jsonString)
    }
}
