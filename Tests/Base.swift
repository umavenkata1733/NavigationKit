

//Banner/Domain/Entities/BannerItem.swift

import Foundation

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
    public let iconName: String
    
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


//Banner/Domain/Configuration/BannerStyleConfiguration.swift


import SwiftUI

/// Styling configurations for banner components
///
/// This structure provides a centralized way to configure the visual styling of banners.
/// It follows the Single Responsibility Principle by focusing only on styling concerns.
public struct BannerStyleConfiguration {
    // MARK: - Properties
    
    /// Primary color used for icons and action text
    public let primaryColor: Color
    
    /// Secondary color used for subtitles
    public let secondaryColor: Color
    
    /// Background color for the banner
    public let backgroundColor: Color
    
    /// Corner radius for the banner
    public let cornerRadius: CGFloat
    
    /// Size of the icon
    public let iconSize: CGFloat
    
    /// Whether to show a shadow under the banner
    public let showShadow: Bool
    
    public let arrowIconImageName: String
    
    // MARK: - Initialization
    
    /// Creates a new style configuration with the specified properties
    ///
    /// - Parameters:
    ///   - primaryColor: Primary color for icons and actions
    ///   - secondaryColor: Secondary color for subtitles
    ///   - backgroundColor: Background color
    ///   - cornerRadius: Corner radius
    ///   - iconSize: Size of the icon
    ///   - showShadow: Whether to show a shadow
    public init(
        primaryColor: Color = .blue,
        secondaryColor: Color = .gray,
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 12,
        iconSize: CGFloat = 45,
        showShadow: Bool = true,
        arrowIconImageName: String = "chevron.right"
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.iconSize = iconSize
        self.showShadow = showShadow
        self.arrowIconImageName = arrowIconImageName
    }
    
    /// Default configuration with standard values
    public static var `default`: BannerStyleConfiguration {
        BannerStyleConfiguration()
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

//Banner/Data/Services/BannerServiceImpl.swift


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


//Banner/Presentation/ViewModels/BannerViewModel.swift


import Foundation
import Combine
import SwiftUI

/// View model for managing banner data in the UI
///
/// This class acts as a bridge between the use cases layer and the UI.
/// It follows the MVVM pattern and the Dependency Inversion Principle by depending on
/// the BannerUseCases protocol rather than a concrete implementation.
public class BannerViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current collection of banner items
    @Published public var banners: [BannerItem] = []
    
    /// Whether data is currently being loaded
    @Published public var isLoading: Bool = false
    
    /// Any error that occurred during loading
    @Published public var error: Error?
    
    // MARK: - Private Properties
    
    /// Use cases that provide banner operations
    private let bannerUseCases: BannerUseCases
    
    /// Cancellable subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Creates a new banner view model
    ///
    /// - Parameter bannerUseCases: The use cases that will provide banner operations
    public init(bannerUseCases: BannerUseCases) {
        self.bannerUseCases = bannerUseCases
        loadBanners()
    }
    
    // MARK: - Public Methods
    
    /// Load all banners
    public func loadBanners() {
        isLoading = true
        error = nil
        
        bannerUseCases.getAllBanners()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] banners in
                    self?.banners = banners
                }
            )
            .store(in: &cancellables)
    }
    
    /// Load banners from a JSON string
    ///
    /// - Parameter jsonString: The JSON string to parse
    public func loadFromJSONString(_ jsonString: String) {
        isLoading = true
        error = nil
        
        bannerUseCases.loadBannersFromJSONString(jsonString)
            .flatMap { _ in
                self.bannerUseCases.getAllBanners()
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] banners in
                    self?.banners = banners
                }
            )
            .store(in: &cancellables)
    }

    /// Get banners of a specific display style
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
}




//Banner/Presentation/Views/BannerViews.swift


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
            .shadow(radius: styleConfig.showShadow ? 2 : 0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Banner list component for displaying multiple banners
///
/// This component is responsible for rendering a collection of banners with a title.
/// It leverages the single banner view for rendering individual items.
public struct BannerListView: View {
    
    // MARK: - Properties
    
    /// Collection of banner items to display
    private let items: [BannerItem]
    
    /// Style configuration for all banners in the list
    private let styleConfig: BannerStyleConfiguration
    
    /// Optional section title
    private let title: String?
    
    /// Action to perform when a banner is tapped
    private let onItemTap: (BannerItem) -> Void
    
    // MARK: - Initialization
    
    /// Creates a new banner list view
    ///
    /// - Parameters:
    ///   - items: Collection of banner items to display
    ///   - styleConfig: Style configuration (optional, defaults to standard styling)
    ///   - title: Optional section title
    ///   - onItemTap: Action to perform when a banner is tapped
    public init(
        items: [BannerItem],
        styleConfig: BannerStyleConfiguration = .default,
        title: String? = nil,
        onItemTap: @escaping (BannerItem) -> Void
    ) {
        self.items = items
        self.styleConfig = styleConfig
        self.title = title
        self.onItemTap = onItemTap
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Optional section title
            if let title = title, !items.isEmpty {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            
            // Banner items
            ForEach(items) { item in
                BannerView(
                    item: item,
                    styleConfig: styleConfig,
                    onTap: onItemTap
                )
                .padding(.horizontal)
            }
        }
    }
}
//
//// MARK: - Preview Providers
//
//struct BannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        BannerView(
//            item: BannerItem(
//                id: "preview-id",
//                title: "Banner Title",
//                subtitle: "This is a preview of a banner item with some long text that might wrap to multiple lines.",
//                iconName: "star.fill",
//                actionText: "Action",
//                hasNavigationArrow: true
//            ),
//            onTap: { _ in }
//        )
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}
//
//struct BannerListView_Previews: PreviewProvider {
//    static var previews: some View {
//        BannerListView(
//            items: [
//                BannerItem(
//                    id: "item1",
//                    title: "First Banner",
//                    subtitle: "First banner description",
//                    iconName: "star.fill"
//                ),
//                BannerItem(
//                    id: "item2",
//                    title: "Second Banner",
//                    subtitle: "Second banner description",
//                    iconName: "heart.fill",
//                    actionText: "Action"
//                )
//            ],
//            title: "Preview Banners",
//            onItemTap: { _ in }
//        )
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}



import Foundation
import Combine

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
    
//    public func loadBannersFromURL(_ url: URL) -> AnyPublisher<Void, Error> {
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .tryMap { data, response -> Data in
//                guard let httpResponse = response as? HTTPURLResponse,
//                      (200...299).contains(httpResponse.statusCode) else {
//                    throw NSError(domain: "BannerUseCases",
//                                 code: 500,
//                                 userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
//                }
//                return data
//            }
//            .flatMap { data -> AnyPublisher<Void, Error> in
//                return Future<Void, Error> { promise in
//                    do {
//                        try self.bannerService.loadFromJSON(data)
//                        promise(.success(()))
//                    } catch {
//                        promise(.failure(error))
//                    }
//                }.eraseToAnyPublisher()
//            }
//            .eraseToAnyPublisher()
//    }
}



import Foundation
import SwiftUI

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
    
    // MARK: - View Creation
    
    /// Creates a banner view for a specific item
    ///
    /// - Parameters:
    ///   - item: The banner item to display
    ///   - styleConfig: Optional style configuration
    ///   - onTap: Action to perform when tapped
    /// - Returns: A configured banner view
    public func makeBannerView(
        item: BannerItem,
        styleConfig: BannerStyleConfiguration = .default,
        onTap: @escaping (BannerItem) -> Void
    ) -> some View {
        return BannerView(
            item: item,
            styleConfig: styleConfig,
            onTap: onTap
        )
    }
    
    /// Creates a banner list view
    ///
    /// - Parameters:
    ///   - items: The banner items to display
    ///   - styleConfig: Optional style configuration
    ///   - title: Optional section title
    ///   - onItemTap: Action to perform when an item is tapped
    /// - Returns: A configured banner list view
    public func makeBannerListView(
        items: [BannerItem],
        styleConfig: BannerStyleConfiguration = .default,
        title: String? = nil,
        onItemTap: @escaping (BannerItem) -> Void
    ) -> some View {
        return BannerListView(
            items: items,
            styleConfig: styleConfig,
            title: title,
            onItemTap: onItemTap
        )
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
                                        print("medical banner tapped: \(item.id)")
                                    }
                                    .padding(.horizontal)
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
                                        print("drugCost banner tapped: \(item.id)")
                                    }
                                    .padding(.horizontal)
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

// Custom view for Cost Estimator items matching the screenshot
struct CostEstimatorItemView: View {
    let item: BannerItem
    let onTap: (BannerItem) -> Void
    /// Style configuration for the banner
    let styleConfig: BannerStyleConfiguration

    var body: some View {
        Button(action: { onTap(item) }) {
            HStack(alignment: .top, spacing: 16) {
                // Icon with square background
                ZStack {
                    Circle()
                        .fill(styleConfig.primaryColor.opacity(0.1))
                        .frame(width: styleConfig.iconSize, height: styleConfig.iconSize)
                    
                    Image(systemName: item.iconName)
                        .font(.system(size: styleConfig.iconSize * 0.4))
                        .foregroundColor(styleConfig.primaryColor)
                }
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundColor(Color(.darkGray))
                }
                
                Spacer()
                
                // Chevron arrow
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
                    .font(.body)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

import XCTest
@testable import Banner

final class BannerServiceImplTests: XCTestCase {
    
    var sut: BannerServiceImpl!
    
    override func setUp() {
        super.setUp()
        sut = BannerServiceImpl()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInit_WithJSONData() throws {
        // Given
        let jsonData = """
        [
            {
                "id": "test-id",
                "title": "Test Title",
                "elements": {
                    "description": {
                        "value": "Test Description"
                    }
                }
            }
        ]
        """.data(using: .utf8)!
        
        // When
        let service = try BannerServiceImpl(jsonData: jsonData)
        
        // Then
        XCTAssertEqual(service.getAllBanners().count, 1, "Should load one banner")
        XCTAssertEqual(service.getAllBanners().first?.id, "test-id", "Should load banner with correct ID")
    }
    
    func testInit_WithJSONString() throws {
        // Given
        let jsonString = """
        [
            {
                "id": "test-id",
                "title": "Test Title",
                "elements": {
                    "description": {
                        "value": "Test Description"
                    }
                }
            }
        ]
        """
        
        // When
        let service = try BannerServiceImpl(jsonString: jsonString)
        
        // Then
        XCTAssertEqual(service.getAllBanners().count, 1, "Should load one banner")
        XCTAssertEqual(service.getAllBanners().first?.id, "test-id", "Should load banner with correct ID")
    }

    func testLoadFromJSON_WithBannerResponse_LoadsBanners() throws {
        // Given
        let jsonData = """
        {
            "banners": [
                {
                    "id": "test-id-1",
                    "title": "Title 1"
                },
                {
                    "id": "test-id-2",
                    "title": "Title 2"
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When
        try sut.loadFromJSON(jsonData)
        
        // Then
        XCTAssertEqual(sut.getAllBanners().count, 2, "Should load 2 banners from response")
    }

}

import XCTest
@testable import Banner

final class BannerMapperTests: XCTestCase {

    func testMapToDomain_WithValueInsteadOfTitle() {
        // Given
        let dto = BannerDTO(
            id: "test-id",
            uuid: nil,
            path: nil,
            name: nil,
            title: "Fallback Title",
            actionText: nil,
            hasNavigationArrow: false,
            displayStyle: nil,
            route: nil,
            elements: [
                "title": ElementDTO(name: "title", value: "Element Value", title: nil, variations: nil)
            ],
            elementsOrder: ["title"]
        )
        
        // When
        let domain = BannerMapper.mapToDomain(dto)
        
        // Then
        XCTAssertEqual(domain.title, "Element Value") // Should use value when title is not available
    }

}


import XCTest
@testable import Banner

final class DTOTests: XCTestCase {
    
    func testBannerResponse_Decoding_Success() throws {
        // Given
        let json = """
        {
            "banners": [
                {
                    "id": "1",
                    "title": "Test Banner"
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When
        let response = try JSONDecoder().decode(BannerResponse.self, from: json)
        
        // Then
        XCTAssertEqual(response.banners.count, 1, "Should decode one banner")
        XCTAssertEqual(response.banners[0].id, "1", "Should decode banner ID correctly")
        XCTAssertEqual(response.banners[0].title, "Test Banner", "Should decode banner title correctly")
    }
}


//import XCTest
//import SwiftUI
//@testable import Banner
//
//final class BannerViewPreviewTests: XCTestCase {
//
//    func testBannerView_Preview_CreatesValidPreview() {
//        // This test validates that the preview doesn't crash
//        let preview = BannerView_Previews.previews
//        XCTAssertNotNil(preview, "Preview should be created successfully")
//    }
//
//    func testBannerListView_Preview_CreatesValidPreview() {
//        let preview = BannerListView_Previews.previews
//        XCTAssertNotNil(preview, "Preview should be created successfully")
//    }
//}

// Note: For full SwiftUI testing, you would normally use ViewInspector
// or similar libraries to test view behavior thoroughly.
// Below is an example of how to do basic testing of view properties

final class BannerViewTests: XCTestCase {
    
    func testBannerView_Initialization() {
        // Given
        let item = BannerItem(
            id: "test-id",
            title: "Test Title",
            subtitle: "Test Subtitle",
            iconName: "star.fill",
            actionText: "Test Action",
            hasNavigationArrow: true
        )
        
        var tappedItem: BannerItem?
        
        // When
        let view = BannerView(
            item: item,
            styleConfig: BannerStyleConfiguration(),
            onTap: { tappedItem = $0 }
        )
        
        // Then - Just verify it doesn't crash
        _ = view.body
    }
    
    func testBannerListView_Initialization() {
        // Given
        let items = [
            BannerItem(
                id: "item1",
                title: "Title 1",
                subtitle: "Subtitle 1",
                iconName: "star.fill"
            ),
            BannerItem(
                id: "item2",
                title: "Title 2",
                subtitle: "Subtitle 2",
                iconName: "heart.fill"
            )
        ]
        
        var tappedItem: BannerItem?
        
        // When
        let view = BannerListView(
            items: items,
            styleConfig: BannerStyleConfiguration(),
            title: "Test List",
            onItemTap: { tappedItem = $0 }
        )
        
        // Then - Just verify it doesn't crash
        _ = view.body
    }
}



// Helper extension to make test code more concise
extension BannerDTO {
    init(id: String, title: String? = nil, elements: [String: ElementDTO]? = nil) {
        self.init(
            id: id,
            uuid: nil,
            path: nil,
            name: nil,
            title: title,
            actionText: nil,
            hasNavigationArrow: nil,
            displayStyle: nil,
            route: nil,
            elements: elements,
            elementsOrder: nil
        )
    }
}

import XCTest
import Combine
@testable import Banner // Replace with your actual module name

final class BannerViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private var sut: BannerViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    
    private func createTestBanner(id: String, style: BannerItem.DisplayStyle = .banner) -> BannerItem {
        return BannerItem(
            id: id,
            title: "Test Title \(id)",
            subtitle: "Test Subtitle \(id)",
            iconName: "star.fill",
            actionText: "Test Action \(id)",
            hasNavigationArrow: true,
            displayStyle: style,
            route: "/test/route/\(id)"
        )
    }
}


import XCTest
import Combine
@testable import Banner // Replace with your actual module name

final class DefaultBannerUseCasesTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mockBannerService: MockBannerService!
    private var sut: DefaultBannerUseCases!
    private var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        mockBannerService = MockBannerService()
        sut = DefaultBannerUseCases(bannerService: mockBannerService)
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        mockBannerService = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    
    private func createTestBanner(id: String, style: BannerItem.DisplayStyle = .banner) -> BannerItem {
        return BannerItem(
            id: id,
            title: "Test Title \(id)",
            subtitle: "Test Subtitle \(id)",
            iconName: "star.fill",
            actionText: "Test Action \(id)",
            hasNavigationArrow: true,
            displayStyle: style,
            route: "/test/route/\(id)"
        )
    }
}

// MARK: - Mock Classes

/// Mock Banner Service implementation
class MockBannerService: BannerService {
    var mockBanners: [BannerItem] = []
    var shouldThrowError = false
    var mockError: Error = NSError(domain: "test", code: 1, userInfo: nil)
    
    var loadFromJSONCalled = false
    var loadFromJSONStringCalled = false
    var loadedJSONString: String?
    var getAllBannersCalled = false
    
    func getAllBanners() -> [BannerItem] {
        getAllBannersCalled = true
        return mockBanners
    }
    
    func getBanners(ofStyle style: BannerItem.DisplayStyle) -> [BannerItem] {
        return mockBanners.filter { $0.displayStyle == style }
    }
    
    func getBanner(withId id: String) -> BannerItem? {
        return mockBanners.first { $0.id == id }
    }
    
    func loadFromJSON(_ jsonData: Data) throws {
        loadFromJSONCalled = true
        if shouldThrowError {
            throw mockError
        }
    }
    
    func loadFromJSONString(_ jsonString: String) throws {
        loadFromJSONStringCalled = true
        loadedJSONString = jsonString
        if shouldThrowError {
            throw mockError
        }
    }
}
