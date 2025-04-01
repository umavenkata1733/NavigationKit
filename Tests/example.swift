//
//  example.swift
//  Reusable
//
//  Created by Anand on 3/30/25.
//

import SwiftUI
import Combine

// MARK: - Examples of Using Reusable Banner Components

/// A view displaying a list of banners using `BannerManagerView`.
/// This view handles loading and displaying banners with customizable configurations.
struct BannerExamplesView: View {
    
    /// StateObject to manage the banner view model and observe its state changes.
    @StateObject private var viewModel: BannerViewModel
    
    /// Initializes the view by creating a `BannerViewModel` using the `BannerFactory`.
    init() {
        let factory = BannerFactory.shared
        _viewModel = StateObject(wrappedValue: factory.makeBannerViewModel())
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    /// Displays a loading indicator when banners are being fetched.
                    if viewModel.isLoading {
                        ProgressView("Loading Banners...")
                    } else {
                        
                        /// Displays the banners using `BannerManagerView` with specified display configurations.
                        BannerManagerView(
                            viewModel: viewModel,
                            displayConfig: BannerDisplayConfig(
                                
                                /// List of specific banners to include for display, identified by their IDs.
                                includeIDs: ["welcome","medical-cost","drug-cost","premium","mentalHealth", "dentalBenefits", "commonly_Used", "medical_plan_123"],
                                
                                /// Optional list of banners to exclude from display. (Currently commented out)
                                // excludeIDs: ["medical-cost", "drug-cost"],
                                
                                /// Group banners visually based on their display style (e.g., banner, list, card).
                                groupByDisplayStyle: true
                            )
                        )
                    }
                }
                .padding(.vertical)
                .background(Color(.systemGray6))
            }
            .navigationTitle("List Of Banners")
            .onAppear {
                /// Loads sample data in JSON format when the view appears.
                loadSampleData()
            }
        }
    }
    
    // MARK: - Data Loading
    
    /// Loads and parses sample JSON data to populate the banners.
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
            },
            {
                "id": "mentalHealth",
                "title": "Get access to mental health and wellness support",
                "displayStyle": "banner",
                "hasNavigationArrow": false,
                "actionText": "Learn about Health and Wellness resources",
                "elements": {
                    "description": {
                        "value": "Learn about our wellness resources to live a healthier tomorrow."
                    },
                    "icon": {
                        "value": "heart.fill"
                    }
                }
            },
            {
                "id": "dentalBenefits",
                "title": "Learn About Dental Benefits",
                "displayStyle": "card",
                "hasNavigationArrow": true,
                "elements": {
                    "description": {
                        "value": "Your plan may offer dental benefits. Visit the support center to find contact information."
                    },
                    "icon": {
                        "value": "leaf.fill"
                    }
                }
            },
            {
                "id": "commonly_Used",
                "title": "Benefits Summary",
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
            "id": "medical_plan_123",
            "title": "Understand Your Plan",
            "elements": {
                "plan_name": {
                    "value": "Medical Plan",
                    "name": "[KP HMO Plan Name]"
                },
                "status": {
                    "value": "Status",
                    "label": true
                },
                "medical_record": {
                    "value": "Medical Record Number",
                    "label": "123456"
                },
                "coverage_start": {
                    "value": "Coverage Start Date",
                    "label": "01/01/2023"
                },
                "region": {
                    "value": "Region",
                    "name": "Southern California"
                },
                "covered_members": {
                    "value": "Who's Covered",
                    "name": "Eric Martinez"
                }
            }
        }

        ]
        """
        
        /// Calls the view model to load banners from the sample JSON data.
        viewModel.loadFromJSONString(jsonString)
    }
}



/// Factory class for creating banner components
///
/// This class provides a centralized way to create banner-related objects
/// with proper dependencies. It serves as a simple dependency injection container.
public class BannerFactory {
    
    // MARK: - Shared Instance
    
    /// Shared factory instance
    public static let shared = BannerFactory()
    
    // MARK: - Initialization
    
    /// Private initializer to ensure singleton usage
    private init() {}
    
    // MARK: - Factory Methods
    
    /// Creates a banner service implementation
    ///
    /// - Returns: A banner service
    public func makeBannerService() -> BannerService {
        return BannerServiceImpl()
    }
    
    /// Creates banner use cases with a banner service
    ///
    /// - Parameter bannerService: Optional banner service (creates a new one if nil)
    /// - Returns: Banner use cases
    public func makeBannerUseCases(bannerService: BannerService? = nil) -> BannerUseCases {
        let service = bannerService ?? makeBannerService()
        return DefaultBannerUseCases(bannerService: service)
    }
    
    /// Creates a banner view model with banner use cases
    ///
    /// - Parameter bannerUseCases: Optional banner use cases (creates new ones if nil)
    /// - Returns: A banner view model
    public func makeBannerViewModel(bannerUseCases: BannerUseCases? = nil) -> BannerViewModel {
        let useCases = bannerUseCases ?? makeBannerUseCases()
        return BannerViewModel(bannerUseCases: useCases)
    }

}

//Banner/Domain/Protocols/BannerService.swift
import Foundation

/// Protocol for providing banner items
///
/// This interface defines the contract for any service that provides banner data.
/// It follows the Interface Segregation Principle by only including methods relevant to
/// banner data management.
public protocol BannerService {
    /// Get all available banner items
    ///
    /// - Returns: An array of all banner items
    func getAllBanners() -> [BannerItem]
    
    /// Get banner items for a specific display style
    ///
    /// - Parameter style: The display style to filter by
    /// - Returns: An array of banner items matching the specified style
    func getBanners(ofStyle style: BannerItem.DisplayStyle) -> [BannerItem]
    
    /// Get a specific banner by ID
    ///
    /// - Parameter id: The unique identifier of the banner
    /// - Returns: The matching banner item, or nil if not found
    func getBanner(withId id: String) -> BannerItem?
    
    /// Load banners from JSON data
    ///
    /// - Parameter jsonData: The JSON data to parse
    /// - Throws: Error if the JSON data cannot be parsed
    func loadFromJSON(_ jsonData: Data) throws
    
    /// Load banners from a JSON string
    ///
    /// - Parameter jsonString: The JSON string to parse
    /// - Throws: Error if the JSON string cannot be parsed
    func loadFromJSONString(_ jsonString: String) throws
}

// MARK: - Banner Use Cases

/// Protocol defining use cases for banner management
///
/// This protocol defines application-specific business logic for banner operations.
/// It represents the "Use Cases" layer of Clean Architecture.
public protocol BannerUseCases {
    /// Get all available banner items
    /// - Returns: A publisher with all banners or an error
    func getAllBanners() -> AnyPublisher<[BannerItem], Error>

    
    /// Load banners from JSON string
    /// - Parameter jsonString: The JSON string to parse
    /// - Returns: A publisher with success or an error
    func loadBannersFromJSONString(_ jsonString: String) -> AnyPublisher<Void, Error>

}

import Foundation

/// Implementation of the BannerService protocol
///
/// This class is responsible for providing banners from data sources and managing banner data.
/// It follows the Dependency Inversion Principle by implementing the domain-level BannerService interface.
public class BannerServiceImpl: BannerService {
    
    // MARK: - Properties
    
    /// Storage for loaded banner items
    private var banners: [BannerItem] = []
    
    // MARK: - Initialization
    
    /// Creates a new banner service with no initial data
    public init() {}
    
    /// Creates a new banner service and loads data from JSON
    ///
    /// - Parameter jsonData: The JSON data to parse
    /// - Throws: Error if the JSON data cannot be parsed
    public init(jsonData: Data) throws {
        try loadFromJSON(jsonData)
    }
    
    /// Creates a new banner service and loads data from a JSON string
    ///
    /// - Parameter jsonString: The JSON string to parse
    /// - Throws: Error if the JSON string cannot be parsed
    public init(jsonString: String) throws {
        try loadFromJSONString(jsonString)
    }
    
    // MARK: - BannerService Protocol Methods
    
    /// Get all available banner items
    ///
    /// - Returns: An array of all banner items
    public func getAllBanners() -> [BannerItem] {
        return banners
    }
    
    /// Get banner items for a specific display style
    ///
    /// - Parameter style: The display style to filter by
    /// - Returns: An array of banner items matching the specified style
    public func getBanners(ofStyle style: BannerItem.DisplayStyle) -> [BannerItem] {
        return banners.filter { $0.displayStyle == style }
    }
    
    /// Get a specific banner by ID
    ///
    /// - Parameter id: The unique identifier of the banner
    /// - Returns: The matching banner item, or nil if not found
    public func getBanner(withId id: String) -> BannerItem? {
        return banners.first { $0.id == id }
    }
    
    /// Load banners from JSON data
    ///
    /// - Parameter jsonData: The JSON data to parse
    /// - Throws: Error if the JSON data cannot be parsed
    public func loadFromJSON(_ jsonData: Data) throws {
        let decoder = JSONDecoder()
        
        do {
            // Try to decode as an array of BannerDTO first
            let dtos = try decoder.decode([BannerDTO].self, from: jsonData)
            banners = dtos.map { BannerMapper.mapToDomain($0) }
        } catch {
            // If that fails, try to decode as a BannerResponse
            let response = try decoder.decode(BannerResponse.self, from: jsonData)
            banners = response.banners.map { BannerMapper.mapToDomain($0) }
        }
    }
    
    /// Load banners from a JSON string
    ///
    /// - Parameter jsonString: The JSON string to parse
    /// - Throws: Error if the JSON string cannot be parsed
    public func loadFromJSONString(_ jsonString: String) throws {
        guard let data = jsonString.data(using: .utf8) else {
            throw NSError(domain: "BannerService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON string"])
        }
        
        try loadFromJSON(data)
    }
}


//Banner/Data/Models/DTOs.swift


import Foundation

// MARK: - Banner Data Models

/// Container for banner collection responses
///
/// Used for parsing JSON responses that include an array of banners in a top-level object.
public struct BannerResponse: Codable {
    /// Collection of banner DTOs
    public let banners: [BannerDTO]
}

/// Data Transfer Object for banner items from JSON
///
/// This model matches the structure of banner data as it comes from external sources.
/// It's separate from the domain model to ensure separation of concerns.
public struct BannerDTO: Codable {
    /// Unique identifier for the banner
    public let id: String
    
    /// Optional UUID for the banner
    public let uuid: String?
    
    /// Content path or category path
    public var path: String?
    
    /// Banner name or identifier
    public var name: String?
    
    /// Display title for the banner
    public let title: String?
    
    /// Call-to-action text
    public let actionText: String?
    
    /// Whether to show a navigation arrow
    public let hasNavigationArrow: Bool?
    
    /// Visual style identifier
    public var displayStyle: String?
    
    /// Navigation route identifier
    public let route: String?
    
    /// Collection of element data indexed by name
    public let elements: [String: ElementDTO]?
    
    /// Ordered list of element names for display order
    public let elementsOrder: [String]?
    
    /// Coding keys for JSON mapping
    enum CodingKeys: String, CodingKey {
        case id, uuid, path, name, title, actionText, hasNavigationArrow, displayStyle, route, elements, elementsOrder
    }
}

/// Data Transfer Object for elements within banner items
///
/// Represents the nested element data structure that can appear within banners.
public struct ElementDTO: Codable {
    /// Element name or identifier
    public let name: String?
    
    /// Element value
    public let value: String?
    
    /// Element title (alternative to value)
    public let title: String?
    
    /// Key-value pairs for different variations of the element
    public let variations: [String: String]?
}



//Banner/Data/Mappers/BannerMapper.swift


import Foundation

/// Mapper to convert BannerDTO to BannerItem domain model
///
/// This class is responsible for transforming data layer objects (DTOs) into domain models.
/// It follows the Single Responsibility Principle by focusing only on mapping between types.
public class BannerMapper {
    
    // MARK: - Mapping Methods
    
    /// Maps a BannerDTO to a BannerItem domain model
    ///
    /// - Parameter dto: The data transfer object to map
    /// - Returns: A fully populated domain model
    public static func mapToDomain(_ dto: BannerDTO) -> BannerItem {
        // Extract values from the dto's elements
        let itemId = getElementValue(dto, for: "id") ?? dto.id
        
        // For title, first try to get it from the elements.title.title path, then elements.title.value, then dto.title
        var itemTitle = ""
        if let titleElement = dto.elements?["title"] {
            itemTitle = titleElement.title ?? titleElement.value ?? dto.title ?? ""
        } else {
            itemTitle = dto.title ?? ""
        }
        
        // For subtitle/description
        var itemSubtitle = ""
        if let descriptionElement = dto.elements?["description"] {
            itemSubtitle = descriptionElement.value ?? ""
        }
        
        // For icon
        var itemIcon = "doc.text" // Default icon
        if let iconElement = dto.elements?["icon"] {
            itemIcon = iconElement.value ?? "doc.text"
        }
        
        // For icon
        var itemStatic = "" // Default icon
        if let iconElement = dto.elements?["plan_name"] {
            itemStatic = iconElement.name ?? ""
        }
        
        // Display style
        let displayStyle: BannerItem.DisplayStyle
        if let styleString = dto.displayStyle {
            displayStyle = BannerItem.DisplayStyle(rawValue: styleString.lowercased()) ?? .banner
        } else if dto.path?.contains("list") == true || dto.name?.contains("list") == true {
            displayStyle = .list
        } else {
            displayStyle = .banner
        }
        
        return BannerItem(
            id: itemId,
            title: itemTitle,
            subtitle: itemSubtitle,
            iconName: itemIcon,
            actionText: dto.actionText,
            hasNavigationArrow: dto.hasNavigationArrow ?? false,
            displayStyle: displayStyle,
            route: dto.route
        )
    }
    
    // MARK: - Helper Methods
    
    /// Gets a value from an element in a DTO
    ///
    /// - Parameters:
    ///   - dto: The data transfer object containing elements
    ///   - elementName: The name of the element to extract
    /// - Returns: The value from the element, or nil if not found
    private static func getElementValue(_ dto: BannerDTO, for elementName: String) -> String? {
        // First check if there's a direct 'title' property in the element for 'title' element
        if elementName == "title" && dto.elements?[elementName]?.title != nil {
            return dto.elements?[elementName]?.title
        }
        
        // Then check for a 'value' property
        return dto.elements?[elementName]?.value
    }
}

/// Default implementation of banner use cases
///
/// This implementation follows the Dependency Inversion Principle by depending on
/// the BannerService protocol rather than a concrete implementation.
public class DefaultBannerUseCases: BannerUseCases {
    
    // MARK: - Properties
    
    /// Service that provides data access
    let bannerService: BannerService
    
    // MARK: - Initialization
    
    /// Creates a new use case layer with a banner service
    /// - Parameter bannerService: The banner service implementation
    public init(bannerService: BannerService) {
        self.bannerService = bannerService
    }
    
    // MARK: - BannerUseCases Implementation
    
    public func getAllBanners() -> AnyPublisher<[BannerItem], Error> {
        // For now, just return the banners directly
        return Just(bannerService.getAllBanners())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func loadBannersFromJSONString(_ jsonString: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                try self.bannerService.loadFromJSONString(jsonString)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
