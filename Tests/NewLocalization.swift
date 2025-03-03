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
