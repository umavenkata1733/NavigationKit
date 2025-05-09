// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
import Combine
// MARK: - Navigation Types and Protocols

/// Navigation types supported by the system
public enum NavigationType: Hashable {
    case push           // Push navigation
    case present       // Modal presentation
    case sheet         // Sheet presentation
    case fullScreen    // Full screen cover
    case alert         // Alert presentation
    case actionSheet   // Action sheet
    case tabItem       // Tab bar item
}

/// Protocol for navigation routes
public protocol NavigationRoute: Hashable, Identifiable {
    var id: String { get }
    var navigationType: NavigationType { get }
}

/// Alert configuration
public struct AlertConfig: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String
    public let primaryButton: AlertButton?
    public let secondaryButton: AlertButton?
    
    public init(
        title: String,
        message: String,
        primaryButton: AlertButton? = nil,
        secondaryButton: AlertButton? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
}

/// Action sheet configuration
public struct ActionSheetConfig: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String?
    public let buttons: [ActionSheetButton]
    
    public init(
        title: String,
        message: String? = nil,
        buttons: [ActionSheetButton]
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
}

/// Button configurations
public struct AlertButton {
    public let title: String
    public let role: ButtonRole?
    public let action: () -> Void
    
    public init(
        title: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.role = role
        self.action = action
    }
}

public struct ActionSheetButton {
    public let title: String
    public let role: ButtonRole?
    public let action: () -> Void
    
    public init(
        title: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.role = role
        self.action = action
    }
}

// MARK: - Navigation State

public final class NavigationState<Route: NavigationRoute>: ObservableObject {
    @Published public var path = NavigationPath()
    @Published public var presentedSheet: Route?
    @Published public var presentedFullScreen: Route?
    @Published public var alertConfig: AlertConfig?
    @Published public var actionSheetConfig: ActionSheetConfig?
    
    // Private properties
    private var navigationStack: [Route] = []
    
    public init() {}
    
    // MARK: - Navigation Methods
    public func navigate(to route: Route) {
        switch route.navigationType {
        case .push:
            navigationStack.append(route)
            path.append(route)
        case .sheet:
            presentedSheet = route
        case .fullScreen:
            presentedFullScreen = route
        default:
            // Handle other navigation types if needed
            break
        }
    }
    
    // MARK: - Dismissal Methods
    public func dismiss() {
        if !navigationStack.isEmpty {
            // Safe removal from navigation stack
            navigationStack.removeLast()
            
            // Only remove from path if it's not empty
            if path.count > 0 {
                path.removeLast()
            }
        } else if presentedSheet != nil {
            presentedSheet = nil
        } else if presentedFullScreen != nil {
            presentedFullScreen = nil
        }
    }
    
    public func popToRoot() {
        navigationStack.removeAll()
        path = NavigationPath()
    }
    
    // MARK: - Alert Methods
    public func showAlert(
        title: String,
        message: String,
        primaryButton: AlertButton? = nil,
        secondaryButton: AlertButton? = nil
    ) {
        alertConfig = AlertConfig(
            title: title,
            message: message,
            primaryButton: primaryButton,
            secondaryButton: secondaryButton
        )
    }
    
    public func dismissAlert() {
        alertConfig = nil
    }
    
    // MARK: - Action Sheet Methods
    public func showActionSheet(
        title: String,
        message: String? = nil,
        buttons: [ActionSheetButton]
    ) {
        actionSheetConfig = ActionSheetConfig(
            title: title,
            message: message,
            buttons: buttons
        )
    }
    
    public func dismissActionSheet() {
        actionSheetConfig = nil
    }
}

// MARK: - NavigationKit/Sources/NavigationKit/NavigationContainer.swift

public struct NavigationContainer<Route: NavigationRoute, Content: View>: View {
    @StateObject var navigationState: NavigationState<Route>
    let content: Content
    let viewBuilder: (Route) -> AnyView
    
    public init(
        state: NavigationState<Route> = NavigationState(),
        @ViewBuilder content: () -> Content,
        viewBuilder: @escaping (Route) -> AnyView
    ) {
        self._navigationState = StateObject(wrappedValue: state)
        self.content = content()
        self.viewBuilder = viewBuilder
    }
    
    public var body: some View {
        NavigationStack(path: $navigationState.path) {
            content
                .navigationDestination(for: Route.self) { route in
                    viewBuilder(route)
                }
                .sheet(item: $navigationState.presentedSheet) { route in
                    NavigationStack {
                        viewBuilder(route)
                    }
                }
                .fullScreenCover(item: $navigationState.presentedFullScreen) { route in
                    NavigationStack {
                        viewBuilder(route)
                    }
                }
                .alert(
                    navigationState.alertConfig?.title ?? "",
                    isPresented: Binding(
                        get: { navigationState.alertConfig != nil },
                        set: { if !$0 { navigationState.alertConfig = nil } }
                    ),
                    presenting: navigationState.alertConfig
                ) { config in
                    if let primary = config.primaryButton {
                        Button(role: primary.role) {
                            primary.action()
                            navigationState.dismissAlert()
                        } label: {
                            Text(primary.title)
                        }
                    }
                    if let secondary = config.secondaryButton {
                        Button(role: secondary.role) {
                            secondary.action()
                            navigationState.dismissAlert()
                        } label: {
                            Text(secondary.title)
                        }
                    }
                } message: { config in
                    Text(config.message)
                }
                .confirmationDialog(
                    navigationState.actionSheetConfig?.title ?? "",
                    isPresented: Binding(
                        get: { navigationState.actionSheetConfig != nil },
                        set: { if !$0 { navigationState.actionSheetConfig = nil } }
                    ),
                    presenting: navigationState.actionSheetConfig
                ) { config in
                    ForEach(config.buttons, id: \.title) { button in
                        Button(role: button.role) {
                            button.action()
                            navigationState.dismissActionSheet()
                        } label: {
                            Text(button.title)
                        }
                    }
                } message: { config in
                    if let message = config.message {
                        Text(message)
                    }
                }
        }
        .environmentObject(navigationState)  // Inject navigationState at the root level
    }
}

// MARK: - NavigationKit/Sources/NavigationKit/AppRoute.swift

public enum AppRoute: NavigationRoute {
    // Main Module Routes
    case home
    case moduleA
    case moduleB
    case settings
    
    // Module A Routes
    case moduleADetail(id: String)
    case moduleASettings
    case moduleAProfile
    
    // Module B Routes
    case moduleBDetail(id: String)
    case moduleBSettings
    case moduleBProfile
    
    // Shared Routes
    case crossModuleFeature(source: String, data: String)
    
    public var id: String {
        switch self {
        case .home: return "home"
        case .moduleA: return "moduleA"
        case .moduleB: return "moduleB"
        case .settings: return "settings"
        case .moduleADetail(let id): return "moduleADetail-\(id)"
        case .moduleASettings: return "moduleASettings"
        case .moduleAProfile: return "moduleAProfile"
        case .moduleBDetail(let id): return "moduleBDetail-\(id)"
        case .moduleBSettings: return "moduleBSettings"
        case .moduleBProfile: return "moduleBProfile"
        case .crossModuleFeature(let source, _): return "crossModule-\(source)"
        }
    }
    
    public var navigationType: NavigationType {
        switch self {
        case .home, .moduleA, .moduleB,
             .moduleADetail, .moduleBDetail:
            return .push
        case .settings, .moduleASettings, .moduleBSettings:
            return .sheet
        case .moduleAProfile, .moduleBProfile:
            return .fullScreen
        case .crossModuleFeature:
            return .push
        }
    }
}
