import XCTest
import Combine
@testable import YourModuleName

// Dummy model for BannerItem
struct BannerItem: Equatable {
    let id: Int
    let title: String
}

// Mock BannerService
class MockBannerService: BannerService {
    var banners: [BannerItem] = []
    var shouldThrowOnLoad = false
    
    func getAllBanners() -> [BannerItem] {
        return banners
    }
    
    func loadFromJSONString(_ jsonString: String) throws {
        if shouldThrowOnLoad {
            throw NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        // Simulate successful parse
    }
}

// Dummy model for BannerItem
struct BannerItem: Equatable {
    let id: Int
    let title: String
}

// Mock BannerService
class MockBannerService: BannerService {
    var banners: [BannerItem] = []
    var shouldThrowOnLoad = false
    
    func getAllBanners() -> [BannerItem] {
        return banners
    }
    
    func loadFromJSONString(_ jsonString: String) throws {
        if shouldThrowOnLoad {
            throw NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        // Simulate successful parse
    }
}



final class DefaultBannerUseCasesTests: XCTestCase {
    
    var mockService: MockBannerService!
    var useCases: DefaultBannerUseCases!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockBannerService()
        useCases = DefaultBannerUseCases(bannerService: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        mockService = nil
        useCases = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetAllBannersReturnsCorrectItems() {
        // Arrange
        let expectedBanners = [
            BannerItem(id: 1, title: "First"),
            BannerItem(id: 2, title: "Second")
        ]
        mockService.banners = expectedBanners
        
        // Act & Assert
        let expectation = self.expectation(description: "getAllBanners")
        
        useCases.getAllBanners()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { banners in
                XCTAssertEqual(banners, expectedBanners)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }

    func testLoadBannersFromJSONStringSuccess() {
        // Act & Assert
        let expectation = self.expectation(description: "loadBannersSuccess")
        
        useCases.loadBannersFromJSONString("{\"valid\": true}")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: {
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }

    func testLoadBannersFromJSONStringFailure() {
        // Arrange
        mockService.shouldThrowOnLoad = true
        
        let expectation = self.expectation(description: "loadBannersFailure")
        
        // Act
        useCases.loadBannersFromJSONString("{\"invalid\": true}")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: {
                XCTFail("Expected failure but got value")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
}

