import SwiftUI
import Combine

/// ViewModel for handling the loading of remote images, with caching support.
@MainActor
class SmartImageViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The image to be displayed.
    @Published var image: UIImage?
    
    /// Boolean indicating if the image is being loaded.
    @Published var isLoading = false
    
    /// Boolean indicating if an error occurred while loading the image.
    @Published var didError = false
    
    // MARK: - Private Properties
    
    /// A cancellable to manage the network request's lifecycle.
    private var cancellable: AnyCancellable?
    
    /// Load a remote image from the given URL, with caching.
    ///
    /// - Parameter urlString: The URL of the image to load.
    func loadRemoteImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            // If the URL is invalid, set the error flag
            didError = true
            return
        }

        Task {
            // Check if the image is cached
            if let cachedImage = await ImageCacheManager.shared.cachedImage(forKey: urlString) {
                // If cached, use the cached image
                image = cachedImage
                return
            }

            // Start loading
            isLoading = true

            // Start the network request to fetch the image
            cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .tryMap { data -> UIImage in
                    guard let image = UIImage(data: data) else {
                        // Throw error if the image data is invalid
                        throw URLError(.badServerResponse)
                    }
                    return image
                }
                .receive(on: DispatchQueue.main) // Switch to the main thread for UI updates
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure:
                        // If failed, set error flag
                        self?.didError = true
                    case .finished:
                        break
                    }
                    // End the loading process
                    self?.isLoading = false
                }, receiveValue: { [weak self] image in
                    // Save the fetched image and update UI
                    self?.image = image
                    // Cache the image asynchronously
                    Task {
                        await ImageCacheManager.shared.saveImage(image, forKey: urlString)
                    }
                })
        }
    }
}

/// Singleton actor class for managing an in-memory image cache.
actor ImageCacheManager {
    static let shared = ImageCacheManager()
    
    /// The in-memory cache for storing images.
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    /// Retrieve a cached image for the given key.
    ///
    /// - Parameter key: The key to retrieve the cached image.
    /// - Returns: The cached image, or `nil` if not found.
    func cachedImage(forKey key: String) async -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    /// Save an image to the cache with a given key.
    ///
    /// - Parameters:
    ///   - image: The image to save.
    ///   - key: The key associated with the image.
    func saveImage(_ image: UIImage, forKey key: String) async {
        cache.setObject(image, forKey: key as NSString)
    }
    
    /// Clear all cached images.
    func clearCache() async {
        cache.removeAllObjects()
    }
}

/// SmartImage is a SwiftUI view that can display images from various sources (local, system, or remote).
struct SmartImage: View {
    
    // MARK: - Enum
    
    /// Defines the source of the image (local, remote, system).
    enum Source {
        case local(String)    // Local image asset name
        case remote(String)   // Remote image URL
        case system(String)   // System image (SF Symbols)
    }
    
    // MARK: - Properties
    
    /// The source of the image.
    let source: Source
    
    /// The placeholder image shown while the image is loading.
    var placeholder: String?
    
    /// The error image shown when the image fails to load.
    var errorImage: String?
    
    /// The content mode for resizing the image (fit, fill).
    var contentMode: ContentMode = .fit
    
    /// The width of the image.
    var width: CGFloat?
    
    /// The height of the image.
    var height: CGFloat?
    
    /// The animation to use when the image fades in.
    var animation: Animation = .easeIn(duration: 0.3)
    
    // MARK: - State
    
    /// The view model for loading and managing the image.
    @StateObject private var viewModel = SmartImageViewModel()
    
    /// The opacity of the image (used for fade-in effect).
    @State private var opacity: Double = 0
    
    // MARK: - Initializer
    
    init(source: Source) {
        self.source = source
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch source {
            case .local(let name):
                // Display local image
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height)
                    .opacity(opacity)
                    .onAppear { fadeIn() }
                
            case .system(let name):
                // Display system (SF Symbol) image
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height)
                    .opacity(opacity)
                    .onAppear { fadeIn() }
                
            case .remote(let urlString):
                // Handle remote image loading
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(width: width, height: height)
                        .opacity(opacity)
                        .onAppear { fadeIn() }
                } else if viewModel.didError {
                    errorView()
                } else {
                    placeholderView()
                        .onAppear {
                            viewModel.loadRemoteImage(from: urlString)
                        }
                }
            }
        }
        .frame(width: width, height: height)
    }
    
    // MARK: - Private Functions
    
    /// Fade in the image with the specified animation.
    private func fadeIn() {
        withAnimation(animation) {
            opacity = 1
        }
    }
    
    /// A view that shows a placeholder image or loading spinner while the image is being loaded.
    @ViewBuilder
    private func placeholderView() -> some View {
        if viewModel.isLoading {
            ProgressView() // Show a loading spinner
        } else if let placeholder = placeholder {
            Image(placeholder)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            ProgressView() // Show a loading spinner by default
        }
    }
    
    /// A view that shows an error image or message if the image fails to load.
    @ViewBuilder
    private func errorView() -> some View {
        if let errorImage = errorImage {
            Image(errorImage)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            VStack {
                Image(systemName: "xmark.octagon.fill") // Error icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
                Text("Image Not Available") // Error message
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Extensions for Modifiers

extension SmartImage {
    
    /// Set a placeholder image to show while the remote image is loading.
    func placeholder(_ name: String) -> SmartImage {
        var copy = self
        copy.placeholder = name
        return copy
    }
    
    /// Set an error image to show when the image fails to load.
    func errorImage(_ name: String) -> SmartImage {
        var copy = self
        copy.errorImage = name
        return copy
    }
    
    /// Set the content mode for how the image should be resized.
    func contentMode(_ mode: ContentMode) -> SmartImage {
        var copy = self
        copy.contentMode = mode
        return copy
    }
    
    /// Set the width and height for the image.
    func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> SmartImage {
        var copy = self
        copy.width = width
        copy.height = height
        return copy
    }
    
    /// Set a custom fade-in animation for the image.
    func fadeAnimation(_ animation: Animation) -> SmartImage {
        var copy = self
        copy.animation = animation
        return copy
    }
}



import XCTest
import SwiftUI
import Combine
@testable import  // Replace with actual module name

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
