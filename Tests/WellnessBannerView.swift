import SwiftUI
import Combine

// SmartImage View - A SwiftUI view that supports displaying images from local, system, or remote sources.
struct SmartImage: View {
    
    // Enum to define the source of the image (local, remote, or system).
    enum Source {
        case local(String)  // Image from local assets
        case remote(String) // Image from a remote URL
        case system(String) // Image from system icons (SF Symbols)
    }
    
    // Properties to manage the image's behavior and appearance.
    private let source: Source  // The image source (local, remote, system)
    private var placeholder: String? // Placeholder image name (for loading state)
    private var errorImage: String? // Image to show when an error occurs
    private var contentMode: ContentMode = .fit // Content mode (scaling behavior)
    private var width: CGFloat? // Image width
    private var height: CGFloat? // Image height
    private var animation: Animation? = .easeIn(duration: 0.3) // Animation for fade-in
    
    @State private var opacity: Double = 0 // State to manage the opacity for fade-in effect
    @State private var image: UIImage? // Cached or loaded image
    @State private var isLoading = false // Loading state
    @State private var didError = false // Error state
    @State private var cancellable: AnyCancellable? // For managing network request cancellation
    
    // Initializer to set the image source.
    init(source: Source) {
        self.source = source
    }
    
    // Main body of the view that renders the image based on the source.
    var body: some View {
        Group {
            switch source {
            case .local(let name):
                // Render local image asset
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height)
                    .opacity(opacity)
                    .onAppear { fadeIn() }
                
            case .system(let name):
                // Render system image (SF Symbols)
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height)
                    .opacity(opacity)
                    .onAppear { fadeIn() }
                
            case .remote(let urlString):
                // Handle remote image loading
                if let image = image {
                    // Render cached or already loaded image
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(width: width, height: height)
                        .opacity(opacity)
                        .onAppear { fadeIn() }
                } else if didError {
                    // Render error state view
                    errorView()
                } else {
                    // Render placeholder while image is loading
                    placeholderView()
                        .onAppear {
                            // Attempt to load from cache, or fetch from network if not cached
                            if let cachedImage = ImageCacheManager.shared.cachedImage(forKey: urlString) {
                                self.image = cachedImage
                                fadeIn()
                            } else {
                                loadRemoteImage(urlString: urlString)
                            }
                        }
                        .onDisappear {
                            cancellable?.cancel() // Cancel loading when view disappears
                        }
                }
            }
        }
        .frame(width: width, height: height) // Set frame size
    }
    
    // Fade-in animation for the image.
    private func fadeIn() {
        withAnimation(animation) {
            opacity = 1 // Gradually reveal the image
        }
    }
    
    // Load a remote image from the provided URL.
    private func loadRemoteImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            didError = true // Handle invalid URL
            return
        }
        
        isLoading = true
        
        // Start loading the remote image via a network request
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) } // Convert response data to UIImage
            .replaceError(with: nil) // Handle errors gracefully by returning nil
            .receive(on: DispatchQueue.main) // Ensure UI updates on the main thread
            .handleEvents(receiveSubscription: { _ in
                isLoading = true
            }, receiveCompletion: { _ in
                isLoading = false
            }, receiveCancel: {
                isLoading = false
            })
            .sink { [self] image in
                if let image = image {
                    self.image = image
                    ImageCacheManager.shared.saveImage(image, forKey: urlString) // Cache the image
                    fadeIn()
                } else {
                    didError = true // If no image, show error state
                }
            }
    }
    
    // View for displaying the placeholder during loading state.
    @ViewBuilder
    private func placeholderView() -> some View {
        if isLoading {
            ProgressView() // Show loading spinner
        } else if let placeholder = placeholder {
            Image(placeholder)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            ProgressView() // Fallback loading spinner
        }
    }
    
    // View for displaying the error state if the image fails to load.
    @ViewBuilder
    private func errorView() -> some View {
        if let errorImage = errorImage {
            Image(errorImage)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            VStack {
                Image(systemName: "xmark.octagon.fill") // Display error icon
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


// MARK: - Modifiers

// Extension to provide customizable modifiers for the SmartImage view.
extension SmartImage {
    func placeholder(_ name: String) -> SmartImage {
        var copy = self
        copy.placeholder = name
        return copy
    }
    
    func errorImage(_ name: String) -> SmartImage {
        var copy = self
        copy.errorImage = name
        return copy
    }
    
    func contentMode(_ mode: ContentMode) -> SmartImage {
        var copy = self
        copy.contentMode = mode
        return copy
    }
    
    func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> SmartImage {
        var copy = self
        copy.width = width
        copy.height = height
        return copy
    }
    
    func fadeAnimation(_ animation: Animation?) -> SmartImage {
        var copy = self
        copy.animation = animation
        return copy
    }
}

// MARK: - Image Cache

// ImageCacheManager - A singleton cache manager for caching images in memory.
class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    // Retrieve a cached image by its key.
    func cachedImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    // Save an image in the cache with the provided key.
    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    // Clear all cached images.
    func clearCache() {
        cache.removeAllObjects()
    }
}


