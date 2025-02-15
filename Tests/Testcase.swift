//
//  Testcase.swift
//  NavigationKit
//
//  Created by Anand on 2/15/25.
//

import XCTest
import SwiftUI
@testable import Moduleersion

final class ModuleersionTests: XCTestCase {
    func testVersion() {
        let version = Moduleersion.version
        XCTAssertEqual(version, "1.0")
    }
}


class SDKConfiguratorTests: XCTestCase {
    var sut: SDKConfigurator!
    var mockConfiguration: SDKConfiguration!
    
    override func setUp() {
        super.setUp()
        sut = SDKConfigurator()
        mockConfiguration = createMockConfiguration()
    }
    
    override func tearDown() {
        sut = nil
        mockConfiguration = nil
        super.tearDown()
    }
    
    @MainActor
    func testBuildComponent() {
        // Given
        // Using the mockConfiguration created in setUp
        
        // When
        let result = sut.buildComponent(configuration: mockConfiguration)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertNotNil(result.viewmodel)
        XCTAssertEqual(result.viewmodel.configuration.baseUrl, "https://test.com")
    }
}

class SDKComponentProviderTests: XCTestCase {
    var sut: SDKComponentProvider!
    var mockConfiguration: SDKConfiguration!
    
    override func setUp() {
        super.setUp()
        sut = SDKComponentProvider()
        mockConfiguration = createMockConfiguration()
    }
    
    override func tearDown() {
        sut = nil
        mockConfiguration = nil
        super.tearDown()
    }
    
    @MainActor
    func testViewControllerCreation() {
        // Given
        // Using the mockConfiguration created in setUp
        
        // When
        let view = sut.viewController(for: mockConfiguration)
        
        // Then
        XCTAssertNotNil(view)
    }
}

class SDKContentManagerTests: XCTestCase {
    var sut: SDKContentManager!
    var mockContentService: MockSDKContentAPI!
    
    override func setUp() {
        super.setUp()
        sut = SDKContentManager()
        mockContentService = MockSDKContentAPI()
    }
    
    override func tearDown() {
        sut = nil
        mockContentService = nil
        super.tearDown()
    }
    
    func testGetContentSummarySuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Content fetched successfully")
        let mockData = MockContent(id: "test")
        let encodedData = try! JSONEncoder().encode(mockData)
        
        // When
        mockContentService.getContentClosure = { contentId, completion in
            DispatchQueue.main.async {
                completion(.success(encodedData))
            }
        }
        
        sut.getContentSummary(contentService: mockContentService, contentId: .SDKFirst) { (content: MockContent?, error) in
            // Then
            XCTAssertNotNil(content)
            XCTAssertNil(error)
            XCTAssertEqual(content?.id, "test")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    
    func testGetContentSummaryFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Content fetch failed")
        let mockError = SDKError.generic
        
        // Mock the content service to return a failure
        mockContentService.getContentClosure = { contentId, completion in
            DispatchQueue.main.async {
                completion(.failure(mockError))
            }
        }
        
        // When
        sut.getContentSummary(contentService: mockContentService, contentId: .SDKFirst) { (content: MockContent?, error) in
            // Then
            XCTAssertNil(content)  // Content should be nil on failure
            XCTAssertNotNil(error) // Error should not be nil
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetContentSummaryDecodingFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Decoding failed")
        let invalidJSON = Data("Invalid JSON".utf8) // Corrupted data

        // Mock the content service to return invalid JSON
        mockContentService.getContentClosure = { contentId, completion in
            DispatchQueue.main.async {
                completion(.success(invalidJSON))
            }
        }
        
        // When
        sut.getContentSummary(contentService: mockContentService, contentId: .SDKFirst) { (content: MockContent?, error) in
            // Then
            XCTAssertNil(content)  // Content should be nil on decoding failure
            XCTAssertNotNil(error) // Error should not be nil
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }


}

// MARK: - Mock Objects

struct MockContent: Codable {
    let id: String
}

class MockSDKContentAPI: SDKContentAPI {
    var getContentClosure: ((ContentID, @escaping (Result<Data, SDKError>) -> Void) -> Void)?
    
    func getContent(content: ContentID, completion: @escaping (Result<Data, SDKError>) -> Void) {
        getContentClosure?(content, completion)
    }
}

class MockServiceAPI: SDKServiceAPI {
    func getService(endPoint: String, completion: @escaping (Result<String, SDKError>) -> Void) {
        completion(.success("Success"))
    }
}

class MockPickerService: SDKPickerService {
    var pickerid: String = "mock_picker"
}

class MockNavigationHandler: SDKNavigationHandler {
    func backAction() {}
}

class MockLocalization: SDKLocalization {
    var defaultLocale: Locale = Locale(identifier: "en_US")
    var availableLocales: [Locale] = [Locale(identifier: "en_US")]
    var bundle: Bundle = Bundle.main
}

// MARK: - Helper Functions

func createMockConfiguration() -> SDKConfiguration {
    return SDKConfiguration(
        serviceAPIStrategy: MockServiceAPI(),
        contentServiceAPIStrategy: MockSDKContentAPI(),
        pickerServices: MockPickerService(),
        navigationActionProvider: MockNavigationHandler(),
        baseUrl: "https://test.com",
        localization: MockLocalization()
    )
}

@MainActor
class SDKViewModelTests: XCTestCase {
    var sut: SDKViewModel!
    var mockConfiguration: SDKConfiguration!
    
    override func setUp() {
        super.setUp()
        mockConfiguration = createMockConfiguration()
        sut = SDKViewModel(configuration: mockConfiguration)
    }
    
    override func tearDown() {
        sut = nil
        mockConfiguration = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.configuration.baseUrl, "https://test.com")
    }
  


}

// Additional test cases to increase coverage

extension SDKViewModelTests {
    func testConfigurationProperties() {
        // Test all configuration properties
        XCTAssertNotNil(sut.configuration.serviceAPIStrategy)
        XCTAssertNotNil(sut.configuration.contentServiceAPIStrategy)
        XCTAssertNotNil(sut.configuration.pickerServices)
        XCTAssertNotNil(sut.configuration.navigationActionProvider)
        XCTAssertNotNil(sut.configuration.localization)
    }
    
    func testLocalizationProperties() {
        let localization = sut.configuration.localization
        XCTAssertEqual(localization.defaultLocale.identifier, "en_US")
        XCTAssertEqual(localization.availableLocales.count, 1)
        XCTAssertNotNil(localization.bundle)
    }
}

extension SDKConfiguratorTests {
    @MainActor
    func testBuildComponentWithDifferentConfiguration() {
        // Given
        let differentConfig = SDKConfiguration(
            serviceAPIStrategy: MockServiceAPI(),
            contentServiceAPIStrategy: MockSDKContentAPI(),
            pickerServices: MockPickerService(),
            navigationActionProvider: MockNavigationHandler(),
            baseUrl: "https://different.com",
            localization: MockLocalization()
        )
        
        // When
        let result = sut.buildComponent(configuration: differentConfig)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result.viewmodel.configuration.baseUrl, "https://different.com")
    }
}

extension SDKComponentProviderTests {
    @MainActor
    func testViewControllerWithDifferentConfigurations() {
        // Test with different base URLs
        let configs = [
            "https://test1.com",
            "https://test2.com",
            "https://test3.com"
        ]
        
        for baseUrl in configs {
            let config = SDKConfiguration(
                serviceAPIStrategy: MockServiceAPI(),
                contentServiceAPIStrategy: MockSDKContentAPI(),
                pickerServices: MockPickerService(),
                navigationActionProvider: MockNavigationHandler(),
                baseUrl: baseUrl,
                localization: MockLocalization()
            )
            
            let view = sut.viewController(for: config)
            XCTAssertNotNil(view)
        }
    }
}

extension SDKContentManagerTests {
  
    
    func testGetContentWithEmptyData() {
        // Given
        let expectation = XCTestExpectation(description: "Empty data")
        let emptyData = Data()
        
        // When
        mockContentService.getContentClosure = { contentId, completion in
            DispatchQueue.main.async {
                completion(.success(emptyData))
            }
        }
        
        sut.getContentSummary(contentService: mockContentService, contentId: .SDKFirst) { (content: MockContent?, error) in
            // Then
            XCTAssertNil(content)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}

class MockPickerServiceTests: XCTestCase {
    func testPickerID() {
        let mockPicker = MockPickerService()
        XCTAssertEqual(mockPicker.pickerid, "mock_picker")
    }
}

class MockNavigationHandlerTests: XCTestCase {
    func testBackAction() {
        let mockNavigation = MockNavigationHandler()
        // Verify that backAction doesn't crash
        mockNavigation.backAction()
    }
}

class MockServiceAPITests: XCTestCase {
    func testGetService() {
        let expectation = XCTestExpectation(description: "Service call")
        let mockService = MockServiceAPI()
        
        mockService.getService(endPoint: "test") { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response, "Success")
            case .failure:
                XCTFail("Should not fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockLocalizationTests: XCTestCase {
    func testLocalizationProperties() {
        let mockLocalization = MockLocalization()
        XCTAssertEqual(mockLocalization.defaultLocale.identifier, "en_US")
        XCTAssertEqual(mockLocalization.availableLocales.count, 1)
        XCTAssertEqual(mockLocalization.availableLocales.first?.identifier, "en_US")
        XCTAssertEqual(mockLocalization.bundle, Bundle.main)
    }
}
