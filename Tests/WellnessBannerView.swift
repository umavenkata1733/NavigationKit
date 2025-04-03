import SwiftUI


// MARK: - Usage Examples
/*
 // Example 1: Load a local image
 SmartImage(source: .local("profile_picture"))
     .frame(width: 100, height: 100)
     .contentMode(.fill)

 // Example 2: Load an SF Symbol
 SmartImage(source: .system("star.fill"))
     .frame(width: 50, height: 50)
     .foregroundColor(.yellow)

 // Example 3: Load a remote image with placeholder and error handling
 SmartImage(source: .remote("https://example.com/avatar.png"))
     .placeholder("loading_placeholder")
     .errorImage("error_icon")
     .frame(width: 150, height: 150)
     .contentMode(.fit)
     .fadeAnimation(.easeInOut(duration: 0.5))
*/

/// A reusable image component that supports local, system, and remote images.
/// It can show a placeholder while the image loads, or an error image if loading fails.
/// Also supports animations and customizable frame size.
struct SmartImage: View {
    
    /// Enum defining the source of the image: local asset, system symbol, or remote URL.
    enum Source {
        case local(String)   // Local asset image (e.g., "profile_pic")
        case remote(String)  // Remote URL string (e.g., "https://example.com/image.jpg")
        case system(String)  // SF Symbol (e.g., "star.fill")
    }
    
    private let source: Source  // The source of the image (local, remote, or system)
    private var placeholder: String?  // The placeholder image to display while loading
    private var errorImage: String?   // The image to display in case of loading failure
    private var contentMode: ContentMode = .fit  // How the image is resized to fit its frame
    private var width: CGFloat?  // The width of the image
    private var height: CGFloat? // The height of the image
    private var animation: Animation? = .easeIn(duration: 0.3) // Animation for fade-in effect
    
    @State private var opacity: Double = 0  // Control opacity for fade-in effect
    
    /// Initializes the `SmartImage` with a specific image source.
    /// - Parameter source: The source of the image (local, remote, or system).
    init(source: Source) {
        self.source = source
    }
    
    var body: some View {
        Group {
            switch source {
            case .local(let name): // Loading image from local assets (e.g., "profile_pic")
                Image(name)
                    .resizable()  // Allows the image to be resized
                    .aspectRatio(contentMode: contentMode)  // Maintains the aspect ratio
                    .frame(width: width, height: height)  // Sets the custom width and height
                    .opacity(opacity)  // Applies the opacity to enable fade-in effect
                    .onAppear { fadeIn() }  // Triggers the fade-in animation on appearance
                    
            case .system(let name): // Loading SF Symbol (e.g., "star.fill")
                Image(systemName: name)
                    .resizable()  // Allows resizing the SF symbol
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height)
                    .opacity(opacity)
                    .onAppear { fadeIn() }
                    
            case .remote(let urlString): // Loading image from a remote URL
                if let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in  // Asynchronously loads the image from the URL
                        switch phase {
                        case .empty:
                            placeholderView()  // Shows the placeholder while the image is loading
                                
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: contentMode)
                                .frame(width: width, height: height)
                                .opacity(opacity)
                                .onAppear { fadeIn() }  // Apply fade-in effect after loading success
                                
                        case .failure:
                            errorView()  // Show an error view if loading the image fails
                                
                        @unknown default:
                            Color.gray  // Default fallback color for unknown states
                        }
                    }
                    .frame(width: width, height: height)  // Ensures the image frame matches custom width and height
                    .transition(.opacity)  // Applies fade-in transition when the image loads
                } else {
                    errorView()  // Show error view if the URL is invalid
                        .frame(width: width, height: height)
                }
            }
        }
    }
    
    /// Triggers the fade-in animation by changing the opacity of the image.
    private func fadeIn() {
        withAnimation(animation) {  // Applying the fade-in animation
            opacity = 1  // Gradually increases the opacity to make the image visible
        }
    }
    
    /// A view that shows a placeholder while the image is being loaded.
    /// - If a placeholder image is provided, it displays that image.
    /// - Otherwise, it shows a progress spinner.
    @ViewBuilder
    private func placeholderView() -> some View {
        if let placeholder = placeholder {
            Image(placeholder)  // Display the provided placeholder image
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            ProgressView()  // Default loading indicator if no placeholder is provided
        }
    }
    
    /// A view shown when an image fails to load.
    /// - If an error image is provided, it displays that image.
    /// - Otherwise, it shows a red "X" symbol and a "Image Not Available" text.
    @ViewBuilder
    private func errorView() -> some View {
        if let errorImage = errorImage {
            Image(errorImage)  // Display the provided error image
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            VStack {  // Display an error symbol and a message
                Image(systemName: "xmark.octagon.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
                Text("Image Not Available")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Modifiers for Customization
extension SmartImage {
    
    /// Sets the placeholder image to be shown while the image is loading.
    /// - Parameter name: The name of the placeholder image.
    /// - Returns: A new `SmartImage` with the placeholder set.
    func placeholder(_ name: String) -> SmartImage {
        var copy = self
        copy.placeholder = name
        return copy
    }
    
    /// Sets the error image to be shown if loading fails.
    /// - Parameter name: The name of the error image.
    /// - Returns: A new `SmartImage` with the error image set.
    func errorImage(_ name: String) -> SmartImage {
        var copy = self
        copy.errorImage = name
        return copy
    }
    
    /// Sets the content mode of the image.
    /// - Parameter mode: The content mode (e.g., `.fit` or `.fill`).
    /// - Returns: A new `SmartImage` with the content mode set.
    func contentMode(_ mode: ContentMode) -> SmartImage {
        var copy = self
        copy.contentMode = mode
        return copy
    }
    
    /// Sets the frame size of the image.
    /// - Parameters:
    ///   - width: The width of the image.
    ///   - height: The height of the image.
    /// - Returns: A new `SmartImage` with the frame size set.
    func frame(width: CGFloat, height: CGFloat) -> SmartImage {
        var copy = self
        copy.width = width
        copy.height = height
        return copy
    }
    
    /// Sets the fade-in animation for the image.
    /// - Parameter animation: The animation to apply to the fade-in effect.
    /// - Returns: A new `SmartImage` with the fade animation set.
    func fadeAnimation(_ animation: Animation) -> SmartImage {
        var copy = self
        copy.animation = animation
        return copy
    }
}

struct ContentView: View {
    var body: some View {
        // Local image
        SmartImage(source: .local("profile_photo"))
            .frame(width: 100, height: 100)

        // System SF Symbol
        SmartImage(source: .system("person.circle.fill"))
            .frame(width: 60, height: 60)

        // Remote image with all options
        SmartImage(source: .remote("https://picsum.photos/id/237/200/300"))
            .placeholder("photo")
            .errorImage( "exclamationmark.triangle")
            .contentMode(.fit)
            .frame(width: 200, height: 200)
            .fadeAnimation(.easeInOut(duration: 0.5))

        SmartImage(source: .remote("http://example.com/image.jpg"))
            .errorImage("myCustomErrorImage")
    }
}
