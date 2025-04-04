import XCTest
import SwiftUI
import Combine

@MainActor
final class SmartImageTests: XCTestCase {
    
    var viewModel: SmartImageViewModel!
    var cacheManager: ImageCacheManager!

    override func setUp() {
        super.setUp()
        viewModel = SmartImageViewModel()
        cacheManager = ImageCacheManager.shared

    }
    
    override func tearDown() {
        viewModel = nil
        cacheManager = nil
        super.tearDown()
    }
    
    func testLocalImageLoad() {
        let smartImage = SmartImage(source: .local("testImage"))
        XCTAssertNotNil(smartImage.body)
    }

    func testSystemImageLoad() {
        let smartImage = SmartImage(source: .system("star.fill"))
        XCTAssertNotNil(smartImage.body)
    }

    func testViewModelHandlesError() async {
        let expectation = XCTestExpectation(description: "Handle invalid URL error")
        
        viewModel.loadRemoteImage(from: "invalid-url")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.viewModel.didError)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }

    func testImageCacheLoad() async {
        let cache = ImageCacheManager.shared
        let testImage = UIImage(systemName: "star.fill")!
        let key = "test_cache_key"

        await cache.saveImage(testImage, forKey: key)
        let cachedImage = await cache.cachedImage(forKey: key)
        
        XCTAssertNotNil(cachedImage)
    }
    
    
    func testErrorViewAppearsOnFailure() async {
        let expectation = XCTestExpectation(description: "Error view should appear on failure")
        
        viewModel.didError = true  // Simulate error
        
        let smartImage = SmartImage(source: .remote("invalid-url"))
            .errorImage("errorImage")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(smartImage.body)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}


// Define a testable version of SmartImage for better unit testing
extension SmartImage {
    // Helper method to expose property values for testing
    func testProperties() -> (
        placeholder: String?,
        errorImage: String?,
        contentMode: ContentMode,
        width: CGFloat?,
        height: CGFloat?,
        animation: Animation
    ) {
        return (
            placeholder: self.placeholder,
            errorImage: self.errorImage,
            contentMode: self.contentMode,
            width: self.width,
            height: self.height,
            animation: self.animation
        )
    }
}

final class SmartImageModifiersTests: XCTestCase {
    
    // Base SmartImage instances for different source types
    var remoteImage: SmartImage!
    var localImage: SmartImage!
    var systemImage: SmartImage!
    
    override func setUp() {
        super.setUp()
        remoteImage = SmartImage(source: .remote("https://example.com/image.jpg"))
        localImage = SmartImage(source: .local("test_local_image"))
        systemImage = SmartImage(source: .system("star.fill"))
    }
    
    override func tearDown() {
        remoteImage = nil
        localImage = nil
        systemImage = nil
        super.tearDown()
    }
    
    // Test SmartImage initialization with different source types
    func testInitialization() {
        // Test remote source
        switch remoteImage.source {
        case .remote(let urlString):
            XCTAssertEqual(urlString, "https://example.com/image.jpg")
        default:
            XCTFail("Expected remote source")
        }
        
        // Test local source
        switch localImage.source {
        case .local(let name):
            XCTAssertEqual(name, "test_local_image")
        default:
            XCTFail("Expected local source")
        }
        
        // Test system source
        switch systemImage.source {
        case .system(let name):
            XCTAssertEqual(name, "star.fill")
        default:
            XCTFail("Expected system source")
        }
    }
    
    // Test the placeholder modifier
    func testPlaceholderModifier() {
        // Apply the placeholder modifier
        let modifiedImage = remoteImage.placeholder("test_placeholder")
        
        // Get properties for testing
        let props = modifiedImage.testProperties()
        
        // Verify the placeholder property was updated
        XCTAssertEqual(props.placeholder, "test_placeholder")
        
        // Verify other properties remain unchanged
        XCTAssertNil(props.errorImage)
        XCTAssertEqual(props.contentMode, .fit)
        XCTAssertNil(props.width)
        XCTAssertNil(props.height)
    }
    
    // Test the errorImage modifier
    func testErrorImageModifier() {
        // Apply the errorImage modifier
        let modifiedImage = remoteImage.errorImage("test_error_image")
        
        // Get properties for testing
        let props = modifiedImage.testProperties()
        
        // Verify the errorImage property was updated
        XCTAssertEqual(props.errorImage, "test_error_image")
        
        // Verify other properties remain unchanged
        XCTAssertNil(props.placeholder)
        XCTAssertEqual(props.contentMode, .fit)
        XCTAssertNil(props.width)
        XCTAssertNil(props.height)
    }
    
    // Test the contentMode modifier
    func testContentModeModifier() {
        // Apply the contentMode modifier
        let modifiedImage = remoteImage.contentMode(.fill)
        
        // Get properties for testing
        let props = modifiedImage.testProperties()
        
        // Verify the contentMode property was updated
        XCTAssertEqual(props.contentMode, .fill)
        
        // Verify other properties remain unchanged
        XCTAssertNil(props.placeholder)
        XCTAssertNil(props.errorImage)
        XCTAssertNil(props.width)
        XCTAssertNil(props.height)
    }
    
    
    // Test chaining multiple modifiers
    func testChainedModifiers() {
        // Apply multiple modifiers in chain
        let modifiedImage = remoteImage
            .placeholder("test_placeholder")
            .errorImage("test_error_image")
            .contentMode(.fill)
            .frame(width: 200, height: 300)
            .fadeAnimation(Animation.linear(duration: 1.0))
        
        // Get properties for testing
        let props = modifiedImage.testProperties()
        
        // Verify all properties were updated correctly
        XCTAssertEqual(props.placeholder, "test_placeholder")
        XCTAssertEqual(props.errorImage, "test_error_image")
        XCTAssertEqual(props.contentMode, .fill)
        XCTAssertEqual(props.width, 200)
        XCTAssertEqual(props.height, 300)
        
        // Verify the original image wasn't modified
        let originalProps = remoteImage.testProperties()
        XCTAssertNil(originalProps.placeholder)
        XCTAssertNil(originalProps.errorImage)
        XCTAssertEqual(originalProps.contentMode, .fit)
        XCTAssertNil(originalProps.width)
        XCTAssertNil(originalProps.height)
    }
    
    @MainActor
    func testLoadRemoteImageWithInvalidURL() {
        let viewModel = SmartImageViewModel()
        viewModel.loadRemoteImage(from: "invalid-url")
        XCTAssertFalse(viewModel.isLoading)
    }

}


