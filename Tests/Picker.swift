//
//  Picker.swift
//  NavigationKit
//
//  Created by Anand on 3/5/25.
//


import Foundation
import Combine

/// Singleton class responsible for managing localization and language switching.
@MainActor
public class LocalizationManager {
    /// Shared instance for the LocalizationManager.
    public static let shared = LocalizationManager()

    private var repository: LocalizationRepositoryProtocol?
    private var languageProvider: AppLanguageProvider?

    private var cancellables = Set<AnyCancellable>()

    private init() {
        // Observe language changes from system settings
        NotificationCenter.default.publisher(for: NSLocale.currentLocaleDidChangeNotification)
            .sink { [weak self] _ in
                self?.updateLanguageFromSystemSettings()
            }
            .store(in: &cancellables)
    }

    /// Initialize the localization manager with repository and language provider.
    /// - Parameters:
    ///   - repository: A repository responsible for fetching localized strings.
    ///   - languageProvider: A provider for managing the app's language.
    public func initialize(repository: LocalizationRepositoryProtocol, languageProvider: AppLanguageProvider) {
        self.repository = repository
        self.languageProvider = languageProvider

        // Set the initial language based on the system settings
        updateLanguageFromSystemSettings()
    }

    /// Update the language based on system settings.
    private func updateLanguageFromSystemSettings() {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        languageProvider?.updateLanguage(to: preferredLanguage)
        repository?.updateLanguage(to: preferredLanguage)
    }

    /// Fetch the localized string for a given key.
    /// - Parameter key: The key for the localized string.
    /// - Returns: The localized string, or the key if no translation is found.
    public func localizedString(forKey key: String) -> String {
        return repository?.fetchLocalizedString(forKey: key) ?? key
    }

    /// Update the language of the application.
    /// - Parameter language: The new language code to switch to (e.g., "en", "es").
    public func updateLanguage(to language: String) {
        languageProvider?.updateLanguage(to: language)
        repository?.updateLanguage(to: language)
    }

    /// Get the current language being used in the application.
    /// - Returns: The language code currently in use (e.g., "en", "es").
    public var currentLanguage: String {
        return languageProvider?.currentLanguage() ?? "en"
    }
}



import Foundation

/// Protocol defining the required methods for a localization repository.
public protocol LocalizationRepositoryProtocol {
    /// Fetch localized string for a given key.
    /// - Parameter key: The key for the localized string.
    /// - Returns: The localized string.
    func fetchLocalizedString(forKey key: String) -> String

    /// Update the language of the repository.
    /// - Parameter language: The new language to switch to.
    func updateLanguage(to language: String)
}

/// Repository responsible for fetching localization strings.
public class LocalizationRepository: LocalizationRepositoryProtocol {
    private var language: String
    private var localizationDataSource: LocalizationDataSourceProtocol

    /// Initialize the localization repository.
    /// - Parameter dataSource: The data source for localization (e.g., JSON or .strings files).
    public init(dataSource: LocalizationDataSourceProtocol) {
        self.language = Locale.preferredLanguages.first ?? "en"
        self.localizationDataSource = dataSource
    }

    /// Fetch the localized string for a given key.
    /// - Parameter key: The key for the localized string.
    /// - Returns: The localized string.
    public func fetchLocalizedString(forKey key: String) -> String {
        return localizationDataSource.fetchString(forKey: key, language: language)
    }

    /// Update the language of the repository.
    /// - Parameter language: The new language to switch to.
    public func updateLanguage(to language: String) {
        self.language = language
    }
}


import Foundation

/// Protocol for the data source that fetches localization data.
public protocol LocalizationDataSourceProtocol {
    /// Fetch the localized string for a given key.
    /// - Parameter key: The key for the localized string.
    /// - Parameter language: The language code (e.g., "en", "es").
    /// - Returns: The localized string.
    func fetchString(forKey key: String, language: String) -> String
}

/// Data source for loading localization data from JSON files.
public class JSONLocalizationDataSource: LocalizationDataSourceProtocol {
    private let bundle: Bundle

    /// Initialize the JSON data source with a specified bundle.
    /// - Parameter bundle: The bundle containing localization files (default is `.module`).
    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    /// Fetch the localized string for a given key.
    /// - Parameter key: The key for the localized string.
    /// - Parameter language: The language code (e.g., "en", "es").
    /// - Returns: The localized string.
    public func fetchString(forKey key: String, language: String) -> String {
        // Load the localization file (en.json, es.json, etc.)
        guard let url = bundle.url(forResource: language, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
            return key
        }
        
        return json[key] ?? key
    }
}


import Foundation

/// Protocol to manage the app's language preferences.
public protocol AppLanguageProvider {
    /// Get the current language.
    /// - Returns: The current language code.
    func currentLanguageGet() -> String

    /// Update the current language.
    /// - Parameter language: The new language to switch to.
    func updateLanguage(to language: String)
}

/// Provider for system language preferences.
public class SystemLanguageProvider: AppLanguageProvider {
    private var currentLanguage: String

    /// Initialize the language provider with a preferred language.
    /// - Parameter preferredLanguage: The language to use (e.g., "en", "es").
    public init(preferredLanguage: String) {
        self.currentLanguage = preferredLanguage
    }

    /// Get the current language.
    /// - Returns: The current language code.
    public func currentLanguageGet() -> String {
        return self.currentLanguage
    }

    /// Update the language.
    /// - Parameter language: The new language code (e.g., "en", "es").
    public func updateLanguage(to language: String) {
        self.currentLanguage = language
    }
}

//import SwiftUI
//
///// A sample localized view that displays a string from the localization manager.
//public struct SPMLocalizedView: View {
//    @State private var localizedString: String = "Hello"
//
//    public init() {}
//
//    public var body: some View {
//        VStack {
//            Text(localizedString)
//                .padding()
//            Button("Switch to Spanish") {
//                LocalizationManager.shared.updateLanguage(to: "es")
//                localizedString = "hello_world".localizedString  // Assuming "hello_world" is a key in the JSON file
//            }
//            Button("Switch to English") {
//                LocalizationManager.shared.updateLanguage(to: "en")
//                localizedString = "hello_world".localizedString  // Assuming "hello_world" is a key in the JSON file
//            }
//        }
//        .onAppear {
//            localizedString = "hello_world".localizedString  // Initial load for the view
//        }
//    }
//}



//Base
//
//import SwiftUI
//import MyLocalizationSDK
//
///// ContentView in the Base App, where we configure the localization.
//struct ContentView: View {
//    init() {
//        // Service and dependencies
//        let repository = LocalizationRepository(dataSource: JSONLocalizationDataSource(bundle: .module)) // Load from the SPM bundle
//        let languageProvider = SystemLanguageProvider(preferredLanguage: Locale.preferredLanguages.first ?? "en")
//
//        // Configure the LocalizationManager with repository and language provider
//        LocalizationManager.shared.initialize(repository: repository, languageProvider: languageProvider)
//    }
//
//    var body: some View {
//        VStack {
//            SPMLocalizedView()
//
//            Button("Switch to Spanish") {
//                LocalizationManager.shared.updateLanguage(to: "es")
//            }
//
//            Button("Switch to English") {
//                LocalizationManager.shared.updateLanguage(to: "en")
//            }
//        }
//    }
//}


/**
 import XCTest
 import MyLocalizationSDK

 /// Unit tests for the LocalizationManager class.
 class LocalizationManagerTests: XCTestCase {

     var localizationManager: LocalizationManager!
     var repository: LocalizationRepositoryProtocol!
     var languageProvider: AppLanguageProvider!

     override func setUp() {
         super.setUp()
         let dataSource = JSONLocalizationDataSource(bundle: Bundle(for: LocalizationManagerTests.self))
         repository = LocalizationRepository(dataSource: dataSource)
         languageProvider = SystemLanguageProvider(preferredLanguage: "en")
         
         localizationManager = LocalizationManager.shared
         localizationManager.initialize(repository: repository, languageProvider: languageProvider)
     }

     /// Test that the LocalizationManager initializes with the correct language.
     func testLocalizationManagerInitialization() {
         XCTAssertEqual(localizationManager.currentLanguage, "en")
     }

     /// Test that the correct localized string is returned for a given key.
     func testLocalizedStringForKey() {
         let localizedString = localizationManager.localizedString(forKey: "hello_world")
         XCTAssertEqual(localizedString, "Hello, World!")
     }

     /// Test that the language can be updated and the correct localized string is returned.
     func testUpdateLanguage() {
         localizationManager.updateLanguage(to: "es")
         XCTAssertEqual(localizationManager.currentLanguage, "es")
         
         let localizedString = localizationManager.localizedString(forKey: "hello_world")
         XCTAssertEqual(localizedString, "¡Hola, Mundo!")
     }
 }

 
 */
//
//import Foundation
//
///// Singleton class responsible for managing localization and language switching.
//@MainActor
//public class LocalizationManager {
//    /// Shared instance for the LocalizationManager.
//    public static let shared = LocalizationManager()
//
//    private var repository: LocalizationRepositoryProtocol?
//    private var languageProvider: AppLanguageProvider?
//
//    private init() {}
//
//    /// Initialize the localization manager with repository and language provider.
//    /// - Parameters:
//    ///   - repository: A repository responsible for fetching localized strings.
//    ///   - languageProvider: A provider for managing the app's language.
//    public func initialize(repository: LocalizationRepositoryProtocol, languageProvider: AppLanguageProvider) {
//        self.repository = repository
//        self.languageProvider = languageProvider
//
//        // Fetch the system preferred language (if not passed explicitly)
//        let preferredLanguage = Locale.preferredLanguages.first ?? "en"  // Default to "en"
//
//        self.languageProvider?.updateLanguage(to: preferredLanguage)
//        self.repository?.updateLanguage(to: preferredLanguage)
//    }
//
//    /// Fetch the localized string for a given key.
//    /// - Parameter key: The key for the localized string.
//    /// - Returns: The localized string, or the key if no translation is found.
//    public func localizedString(forKey key: String) -> String {
//        return repository?.fetchLocalizedString(forKey: key) ?? key
//    }
//
//    /// Update the language of the application.
//    /// - Parameter language: The new language code to switch to (e.g., "en", "es").
//    public func updateLanguage(to language: String) {
//        languageProvider?.updateLanguage(to: language)
//        repository?.updateLanguage(to: language)
//    }
//
//    /// Get the current language being used in the application.
//    /// - Returns: The language code currently in use (e.g., "en", "es").
//    public var currentLanguage: String {
//        return languageProvider?.currentLanguageGet() ?? "en"
//    }
//}
//
///// Protocol defining the required methods for a localization repository.
//public protocol LocalizationRepositoryProtocol {
//    /// Fetch localized string for a given key.
//    /// - Parameter key: The key for the localized string.
//    /// - Returns: The localized string.
//    func fetchLocalizedString(forKey key: String) -> String
//
//    /// Update the language of the repository.
//    /// - Parameter language: The new language to switch to.
//    func updateLanguage(to language: String)
//}
//
///// Repository responsible for fetching localization strings.
//public class LocalizationRepository: LocalizationRepositoryProtocol {
//    private var language: String
//    private var localizationDataSource: LocalizationDataSourceProtocol
//
//    /// Initialize the localization repository.
//    /// - Parameter dataSource: The data source for localization (e.g., JSON or .strings files).
//    public init(dataSource: LocalizationDataSourceProtocol) {
//        self.language = Locale.preferredLanguages.first ?? "en"
//        self.localizationDataSource = dataSource
//    }
//
//    /// Fetch the localized string for a given key.
//    /// - Parameter key: The key for the localized string.
//    /// - Returns: The localized string.
//    public func fetchLocalizedString(forKey key: String) -> String {
//        return localizationDataSource.fetchString(forKey: key, language: language)
//    }
//
//    /// Update the language of the repository.
//    /// - Parameter language: The new language to switch to.
//    public func updateLanguage(to language: String) {
//        self.language = language
//    }
//}
//
///// Protocol for the data source that fetches localization data.
//public protocol LocalizationDataSourceProtocol {
//    /// Fetch the localized string for a given key.
//    /// - Parameter key: The key for the localized string.
//    /// - Parameter language: The language code (e.g., "en", "es").
//    /// - Returns: The localized string.
//    func fetchString(forKey key: String, language: String) -> String
//}
//
///// Data source for loading localization data from JSON files.
//public class JSONLocalizationDataSource: LocalizationDataSourceProtocol {
//    private let bundle: Bundle
//
//    /// Initialize the JSON data source with a specified bundle.
//    /// - Parameter bundle: The bundle containing localization files (default is `.main`).
//    public init(bundle: Bundle = .main) {
//        self.bundle = bundle
//    }
//
//    /// Fetch the localized string for a given key.
//    /// - Parameter key: The key for the localized string.
//    /// - Parameter language: The language code (e.g., "en", "es").
//    /// - Returns: The localized string.
//    public func fetchString(forKey key: String, language: String) -> String {
//        // Load the localization file (en.json, es.json, etc.)
//        guard let url = bundle.url(forResource: language, withExtension: "json"),
//              let data = try? Data(contentsOf: url),
//              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
//            return key
//        }
//
//        return json[key] ?? key
//    }
//}
//
//
///// Protocol to manage the app's language preferences.
//public protocol AppLanguageProvider {
//    /// Get the current language.
//    /// - Returns: The current language code.
//    func currentLanguageGet() -> String
//
//    /// Update the current language.
//    /// - Parameter language: The new language to switch to.
//    func updateLanguage(to language: String)
//}
//
///// Provider for system language preferences.
//public class SystemLanguageProvider: AppLanguageProvider {
//    private var currentLanguage: String
//
//    /// Initialize the language provider with a preferred language.
//    /// - Parameter preferredLanguage: The language to use (e.g., "en", "es").
//    public init(preferredLanguage: String) {
//        self.currentLanguage = preferredLanguage
//    }
//
//    /// Get the current language.
//    /// - Returns: The current language code.
//    public func currentLanguageGet() -> String {
//        return self.currentLanguage
//    }
//
//    /// Update the language.
//    /// - Parameter language: The new language code (e.g., "en", "es").
//    public func updateLanguage(to language: String) {
//        self.currentLanguage = language
//    }
//}
//
//import Foundation
//
///// Extension to easily fetch localized strings directly from `String`.
//extension String {
//    /// Retrieve the localized version of a string.
//    /// - Returns: The localized string for the current language.
//    @MainActor
//    public var localizedString: String {
//        return LocalizationManager.shared.localizedString(forKey: self)
//    }
//}
