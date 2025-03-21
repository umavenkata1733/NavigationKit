//
//  NewLocalization.swift
//  NavigationKit
//
//  Created by Anand on 3/3/25.
//

import Foundation
import Combine

// MARK: - Localization Service Protocol
/// Protocol for localization services to provide localized strings.
public protocol LocalizationServiceProtocol {
    /// Retrieves a localized string for the given key and table name.
    /// - Parameters:
    ///   - key: Localization key.
    ///   - tableName: Table name in the localization resource.
    /// - Returns: Localized string.
    func localizedString(forKey key: String, tableName: String) -> String
}

// MARK: - Strings-based Localization Service
/// Localization service that retrieves localized strings from .strings files.
public class StringsLocalizationService: LocalizationServiceProtocol {
    private let bundle: Bundle

    /// Initializes the service with a specified bundle.
    /// - Parameter bundle: The bundle containing localization files.
    public init(bundle: Bundle) {
        self.bundle = bundle
    }

    /// Retrieves a localized string from the .strings file.
    public func localizedString(forKey key: String, tableName: String) -> String {
        return NSLocalizedString(key, tableName: tableName, bundle: bundle, value: key, comment: key)
    }
}

// MARK: - JSON-based Localization Service
/// Localization service that retrieves localized strings from JSON files.
public class JSONLocalizationService: LocalizationServiceProtocol {
    private var translations: [String: String] = [:]

    /// Initializes the service and loads translations from a JSON file.
    /// - Parameters:
    ///   - languageCode: The language code (e.g., "en", "fr").
    ///   - bundle: The bundle containing localization files.
    public init(languageCode: String, bundle: Bundle) {
        loadTranslations(for: languageCode, from: bundle)
    }

    /// Loads translation data from the corresponding JSON file.
    /// - Parameters:
    ///   - languageCode: The language code.
    ///   - bundle: The bundle containing the JSON file.
    private func loadTranslations(for languageCode: String, from bundle: Bundle) {
        guard let url = bundle.url(forResource: languageCode, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
            return
        }
        translations = json
    }

    /// Retrieves the localized string from the JSON dictionary.
    public func localizedString(forKey key: String, tableName: String) -> String {
        return translations[key] ?? key
    }
}

// MARK: - Localization Manager
/// Manages the current localization service and updates when language changes.
public class LocalizationManager: ObservableObject {
    @Published private(set) var service: LocalizationServiceProtocol
    private let serviceFactory: (String, Bundle) -> LocalizationServiceProtocol
    private let bundle: Bundle

    /// Initializes the localization manager.
    /// - Parameters:
    ///   - serviceFactory: Factory function to create localization services.
    ///   - initialLanguage: The initial language to use.
    ///   - bundle: The bundle containing localization files.
    public init(serviceFactory: @escaping (String, Bundle) -> LocalizationServiceProtocol,
                initialLanguage: String = Locale.preferredLanguages.first ?? "en",
                bundle: Bundle) {
        self.serviceFactory = serviceFactory
        self.bundle = bundle
        self.service = serviceFactory(initialLanguage, bundle)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(languageDidChange),
            name: NSLocale.currentLocaleDidChangeNotification,
            object: nil
        )
    }

    /// Detects system language changes and updates the localization service.
    @objc private func languageDidChange() {
        let newLanguageCode = Locale.preferredLanguages.first ?? "en"
        updateLanguage(to: newLanguageCode)
    }

    /// Updates the localization service to use a new language.
    /// - Parameter languageCode: The new language code.
    public func updateLanguage(to languageCode: String) {
        self.service = serviceFactory(languageCode, bundle)
        objectWillChange.send()
    }

    /// Retrieves a localized string based on the provided key.
    /// - Parameter key: The localization key.
    /// - Returns: The localized string.
    public func localizedString(forKey key: LocalizationKeyProtocol) -> String {
        return service.localizedString(forKey: key.rawValue, tableName: key.tableName)
    }
    
    /// Removes observer when the object is deallocated.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Localization Keys Protocol
/// Defines a protocol for localization keys, ensuring type safety.
public protocol LocalizationKeyProtocol {
    var tableName: String { get }
    var rawValue: String { get }
}

// MARK: - Screen-specific Localization Keys
/// Defines keys for Home screen localization.
public enum HomeLocalizationKey: String, LocalizationKeyProtocol {
    case welcomeMessage = "welcome_message"
    case homeTitle = "home_title"
    
    public var tableName: String {
        return "HomeLocalizable"
    }
}

/// Defines keys for Profile screen localization.
public enum ProfileLocalizationKey: String, LocalizationKeyProtocol {
    case profileTitle = "profile_title"
    case logoutMessage = "logout_message"
    
    public var tableName: String {
        return "ProfileLocalizable"
    }
}

/// Defines keys for Settings screen localization.
public enum SettingsLocalizationKey: String, LocalizationKeyProtocol {
    case settingsTitle = "settings_title"
    case languageOption = "language_option"
    
    public var tableName: String {
        return "SettingsLocalizable"
    }
}

// MARK: - String Extension for Localization
/// Provides a convenience method for retrieving localized strings.
public extension LocalizationManager {
    /// Retrieves the localized string using the given key.
    /// - Parameter key: The localization key.
    /// - Returns: The localized string.
    func localized(_ key: LocalizationKeyProtocol) -> String {
        return localizedString(forKey: key)
    }
}


import XCTest
@testable import YourLocalizationPackage

// MARK: - Mock Localization Storage
class MockLocalizationService: LocalizationServiceProtocol {
    private let translations: [String: String]
    
    init(translations: [String: String]) {
        self.translations = translations
    }
    
    func localizedString(forKey key: String, tableName: String) -> String {
        return translations[key] ?? key
    }
}

// MARK: - Localization Tests
final class LocalizationTests: XCTestCase {
    private var localizationManager: LocalizationManager!
    private var mockBundle: Bundle!
    
    override func setUp() {
        super.setUp()
        mockBundle = Bundle(for: type(of: self))
        localizationManager = LocalizationManager(serviceFactory: { language, _ in
            let mockTranslations = [
                "welcome_message": language == "fr" ? "Bienvenue" : "Welcome",
                "home_title": language == "fr" ? "Accueil" : "Home"
            ]
            return MockLocalizationService(translations: mockTranslations)
        }, initialLanguage: "en", bundle: mockBundle)
    }
    
    override func tearDown() {
        localizationManager = nil
        super.tearDown()
    }
    
    func testLocalizationRetrieval() {
        XCTAssertEqual(localizationManager.localized(HomeLocalizationKey.welcomeMessage), "Welcome")
        XCTAssertEqual(localizationManager.localized(HomeLocalizationKey.homeTitle), "Home")
    }
    
    func testLanguageSwitching() {
        localizationManager.updateLanguage(to: "fr")
        XCTAssertEqual(localizationManager.localized(HomeLocalizationKey.welcomeMessage), "Bienvenue")
        XCTAssertEqual(localizationManager.localized(HomeLocalizationKey.homeTitle), "Accueil")
    }
    
    func testFallbackMechanism() {
        localizationManager.updateLanguage(to: "de") // No German translations provided
        XCTAssertEqual(localizationManager.localized(HomeLocalizationKey.welcomeMessage), "welcome_message")
    }
}









import XCTest
@testable import YourModuleName // Replace with your actual module name

class LocalizationManagerTests: XCTestCase {
    
    // Mock protocols and classes
    protocol LocalizationServiceProtocol {
        func localizedString(forKey key: String, tableName: String) -> String
    }
    
    protocol LocalizationKeyProtocol {
        var rawValue: String { get }
        var tableName: String { get }
    }
    
    class MockLocalizationService: LocalizationServiceProtocol {
        let languageCode: String
        let bundle: Bundle
        var localizedStrings: [String: String] = [:]
        
        init(languageCode: String, bundle: Bundle) {
            self.languageCode = languageCode
            self.bundle = bundle
        }
        
        func localizedString(forKey key: String, tableName: String) -> String {
            return localizedStrings[key] ?? key
        }
    }
    
    enum MockLocalizationKey: String, LocalizationKeyProtocol {
        case welcome = "welcome_key"
        
        var tableName: String {
            return "MockTable"
        }
    }
    
    // Test properties
    var testBundle: Bundle!
    var mockFactory: ((String, Bundle) -> LocalizationServiceProtocol)!
    var lastCreatedService: MockLocalizationService?
    
    override func setUp() {
        super.setUp()
        testBundle = Bundle(for: type(of: self))
        
        // Setup a factory that creates mock services and records the last one created
        mockFactory = { [weak self] (languageCode, bundle) in
            let service = MockLocalizationService(languageCode: languageCode, bundle: bundle)
            self?.lastCreatedService = service
            return service
        }
    }
    
    override func tearDown() {
        testBundle = nil
        mockFactory = nil
        lastCreatedService = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitWithExplicitLanguage() {
        // Initialize with explicit language code
        let manager = LocalizationManager(
            serviceFactory: mockFactory,
            initialLanguage: "fr",
            bundle: testBundle
        )
        
        // Verify the service was created with the correct parameters
        XCTAssertEqual(lastCreatedService?.languageCode, "fr")
        XCTAssertIdentical(lastCreatedService?.bundle, testBundle)
        
        // Verify the service was assigned to the manager
        if let mockService = manager.service as? MockLocalizationService {
            XCTAssertEqual(mockService.languageCode, "fr")
            XCTAssertIdentical(mockService.bundle, testBundle)
        } else {
            XCTFail("Manager's service is not of expected type")
        }
    }
    
    func testInitWithDefaultLanguage() {
        // Initialize without specifying language (should use system's preferred)
        let expectedLanguage = Locale.preferredLanguages.first ?? "en"
        
        let manager = LocalizationManager(
            serviceFactory: mockFactory,
            bundle: testBundle
        )
        
        // Verify the service was created with the expected language
        XCTAssertEqual(lastCreatedService?.languageCode, expectedLanguage)
        XCTAssertIdentical(lastCreatedService?.bundle, testBundle)
    }
    
    func testInitRegistersForNotifications() {
        // Keep a weak reference to avoid preventing deallocation
        weak var weakManager: LocalizationManager?
        
        // Create in a scope to allow for deallocation
        autoreleasepool {
            let manager = LocalizationManager(
                serviceFactory: mockFactory,
                initialLanguage: "en",
                bundle: testBundle
            )
            
            weakManager = manager
            
            // Verify the observer was added (indirectly)
            // Note: We can't directly test private properties like the observer
            
            // Simulate the notification to see if it triggers the observer
            let oldService = lastCreatedService
            NotificationCenter.default.post(name: NSLocale.currentLocaleDidChangeNotification, object: nil)
            
            // If the observer was correctly added, the service should have been recreated
            XCTAssertNotIdentical(manager.service as AnyObject, oldService as AnyObject)
        }
        
        // Verify manager is properly deallocated (which indirectly tests deinit and observer removal)
        XCTAssertNil(weakManager, "Manager should be deallocated")
    }
    
    func testFactoryIsStoredCorrectly() {
        // Initialize the manager
        let manager = LocalizationManager(
            serviceFactory: mockFactory,
            initialLanguage: "en",
            bundle: testBundle
        )
        
        // Clear the last created service
        lastCreatedService = nil
        
        // Update the language which should use the stored factory
        manager.updateLanguage(to: "es")
        
        // Verify the factory was called with the correct parameters
        XCTAssertEqual(lastCreatedService?.languageCode, "es")
        XCTAssertIdentical(lastCreatedService?.bundle, testBundle)
    }
}

func testLanguageDidChangeNotification() {
    let expectation = self.expectation(description: "Language change should trigger an update")

    // Initial language setup
    localizationManager.updateLanguage(to: "en")
    XCTAssertEqual(localizationManager.localized(HomeLocalizationKey.welcomeMessage), "Welcome")

    // Observe the object change
    let cancellable = localizationManager.objectWillChange.sink {
        expectation.fulfill() // Expectation is fulfilled when language changes
    }

    // Post the system language change notification
    NotificationCenter.default.post(name: NSLocale.currentLocaleDidChangeNotification, object: nil)

    // Wait for expectation to be fulfilled
    wait(for: [expectation], timeout: 1.0)
    
    // Ensure the language is updated
    let newLanguageCode = Locale.preferredLanguages.first ?? "en"
    let expectedTranslation = newLanguageCode == "fr" ? "Bienvenue" : "Welcome"
    
    XCTAssertEqual(localizationManager.localized(HomeLocalizationKey.welcomeMessage), expectedTranslation)

    cancellable.cancel()
}



import SwiftUI
import YourLocalizationPackage // Replace with actual module name

struct ContentView: View {
    @StateObject private var localizationManager = LocalizationManager(
        serviceFactory: { language, bundle in
            JSONLocalizationService(languageCode: language, bundle: bundle)
        },
        bundle: Bundle.main
    )
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(localizationManager.localized(HomeLocalizationKey.welcomeMessage))
                    .font(.largeTitle)
                    .padding()

                Text(localizationManager.localized(HomeLocalizationKey.homeTitle))
                    .font(.title2)
                    .foregroundColor(.gray)

                Picker("Language", selection: Binding(
                    get: { Locale.preferredLanguages.first ?? "en" },
                    set: { localizationManager.updateLanguage(to: $0) }
                )) {
                    Text("English").tag("en")
                    Text("French").tag("fr")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                NavigationLink(destination: ProfileView(localizationManager: localizationManager)) {
                    Text(localizationManager.localized(HomeLocalizationKey.homeTitle))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle(localizationManager.localized(HomeLocalizationKey.homeTitle))
        }
    }
}




import XCTest
@testable import YourModuleName  // Replace with your actual module name

class BNCNetworkManagerTests: XCTestCase {
    
    var mockManager: BNCNetworkManager!
    var mockAdapter: MockNetworkAdapter!
    var mockService: MockBNCBenefitsBffService!
    var mockEnvironment: MockBNCMobileServiceEnvironment!
    
    override func setUp() {
        super.setUp()
        mockAdapter = MockNetworkAdapter()
        mockService = MockBNCBenefitsBffService()
        mockEnvironment = MockBNCMobileServiceEnvironment()
        mockManager = BNCNetworkManager(environment: mockEnvironment, bffService: mockService)
    }
    
    override func tearDown() {
        mockManager = nil
        mockAdapter = nil
        mockService = nil
        mockEnvironment = nil
        super.tearDown()
    }
    
    /// Test successful request
    func testSendRequest_Success() {
        // Given
        let mockData = MockResponse(id: 1, name: "Test")
        let mockResponse = MockNetworkResponse(statusCode: 200, header: [:])
        let mockRequest = MockNetworkRequest()
        
        mockAdapter.mockResult = .success(mockData, mockResponse, mockRequest)
        
        let expectation = self.expectation(description: "Success Case")
        
        // When
        mockManager.sendRequest(endpoint: MockEndpoint.test, expecting: MockResponse.self) { result in
            // Then
            switch result {
            case .success(let data, _, _):
                XCTAssertEqual(data.id, 1)
                XCTAssertEqual(data.name, "Test")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /// Test failure request
    func testSendRequest_Failure() {
        // Given
        let mockError = NetworkError.timeout
        let mockResponse = MockNetworkResponse(statusCode: 500, header: [:])
        
        mockAdapter.mockResult = .failure(mockError, mockResponse, nil)
        
        let expectation = self.expectation(description: "Failure Case")
        
        // When
        mockManager.sendRequest(endpoint: MockEndpoint.test, expecting: MockResponse.self) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error, _, _):
                XCTAssertEqual(error, NetworkError.timeout)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}

// MARK: - Mock Classes

class MockNetworkAdapter: NetworkAdapter {
    var mockResult: NetworkDecodedResult<MockResponse>?
    
    override func sendRequest<T: Decodable>(to endPoint: Endpoint, in environment: Environment, expecting: T.Type) async throws -> NetworkDecodedSuccess<T> {
        guard let result = mockResult as? NetworkDecodedResult<T> else {
            throw NetworkError.timeout
        }
        
        switch result {
        case .success(let data, let response, let request):
            return NetworkDecodedSuccess(decoded: data, response: response, request: request)
        case .failure(let error, _, _):
            throw error
        }
    }
}

class MockNetworkResponse: NetwokResponse {
    var statusCode: Int
    var header: [String: String]
    
    init(statusCode: Int, header: [String: String]) {
        self.statusCode = statusCode
        self.header = header
    }
    
    func localizedString(forStatusCode statusCode: Int) -> String {
        return "Mock Status Code: \(statusCode)"
    }
}

class MockNetworkRequest: NetworkRequest {
    var url: URL? { return URL(string: "https://mockurl.com") }
    var httpMethod: String? { return "GET" }
    var allHttpHeaderFields: [String: String]? { return [:] }
    var httpBody: Data? { return nil }
    required init?(to endPoint: Endpoint, in environment: Environment, including body: Data?) {}
}

class MockBNCBenefitsBffService: BNCBenefitsBffService {
    func getRequiredBffHeaders(for endPoint: BNCMobileEndpoint) -> [String: String] {
        return ["Authorization": "Bearer MockToken"]
    }
    func validateResponse<T: Decodable>(for response: NetworkDecodedResult<T>) -> Bool {
        return true
    }
}

class MockBNCMobileServiceEnvironment: BNCMobileServiceEnvironment {
    override init(baseURL: URL = URL(string: "https://mockapi.com")!) {
        super.init(baseURL: baseURL)
    }
}
