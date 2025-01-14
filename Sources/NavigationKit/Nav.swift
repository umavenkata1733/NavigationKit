// Package.swift (Root)
import SwiftUI
import Combine


// Sources/Common/Coordinator.swift

public protocol Coordinator: AnyObject {
    associatedtype Route
    associatedtype ViewType: View
    
    var navigationPath: NavigationPath { get set }
    var sheet: Route? { get set }
    
    func handle(_ route: Route)
    func view() -> ViewType
}

// Sources/Common/ViewModifier.swift

public struct CoordinatorViewModifier<T: Coordinator>: ViewModifier {
    @ObservedObject var coordinator: StateObject<T>.Wrapper
    
    public init(coordinator: StateObject<T>.Wrapper) {
        self.coordinator = coordinator
    }
    
    public func body(content: Content) -> some View {
        content
            .navigationPath(coordinator.wrappedValue.navigationPath)
            .sheet(item: coordinator.projectedValue.sheet) { route in
                coordinator.wrappedValue.handle(route)
            }
    }
}

// Sources/Navigation/NavigationNode.swift
import Foundation

public enum NavigationNode: Hashable {
    case category
    case articleDetail(articleId: String)
    case filter
    case filterTagCollection
}

// Sources/Home/Presentation/HomeCoordinator.swift

public class HomeCoordinator: ObservableObject, Coordinator {
    @Published public var navigationPath = NavigationPath()
    @Published public var sheet: NavigationNode?
    
    public init() {}
    
    public func handle(_ route: NavigationNode) {
        switch route {
        case .category:
            navigationPath.append(route)
        default:
            break
        }
    }
    
    public func view() -> some View {
        HomeView(coordinator: self)
    }
}

// Sources/Home/Presentation/HomeView.swift
public struct HomeView: View {
    @ObservedObject var coordinator: HomeCoordinator
    
    public var body: some View {
        VStack {
            Text("Home")
                .font(.title)
            
            Button("Go to Category") {
                coordinator.handle(.category)
            }
        }
    }
}

// Sources/Category/Presentation/CategoryCoordinator.swift

public class CategoryCoordinator: ObservableObject, Coordinator {
    @Published public var navigationPath = NavigationPath()
    @Published public var sheet: NavigationNode?
    
    public init() {}
    
    public func handle(_ route: NavigationNode) {
        switch route {
        case .articleDetail:
            navigationPath.append(route)
        case .filter:
            sheet = route
        default:
            break
        }
    }
    
    public func view() -> some View {
        CategoryView(coordinator: self)
    }
}

// Sources/Category/Presentation/CategoryView.swift
import SwiftUI

public struct CategoryView: View {
    @ObservedObject var coordinator: CategoryCoordinator
    
    public var body: some View {
        VStack {
            Text("Category")
                .font(.title)
            
            Button("Show Article") {
                coordinator.handle(.articleDetail(articleId: "123"))
            }
            
            Button("Show Filter") {
                coordinator.handle(.filter)
            }
        }
    }
}

// Sources/Article/Presentation/ArticleCoordinator.swift


public class ArticleCoordinator: ObservableObject, Coordinator {
    @Published public var navigationPath = NavigationPath()
    @Published public var sheet: NavigationNode?
    private let articleId: String
    
    public init(articleId: String) {
        self.articleId = articleId
    }
    
    public func handle(_ route: NavigationNode) {}
    
    public func view() -> some View {
        ArticleView(coordinator: self, articleId: articleId)
    }
}

// Sources/Article/Presentation/ArticleView.swift
import SwiftUI

public struct ArticleView: View {
    @ObservedObject var coordinator: ArticleCoordinator
    let articleId: String
    
    public var body: some View {
        VStack {
            Text("Article Detail")
                .font(.title)
            Text("ID: \(articleId)")
        }
    }
}

// Sources/Filter/Presentation/FilterCoordinator.swift


public class FilterCoordinator: ObservableObject, Coordinator {
    @Published public var navigationPath = NavigationPath()
    @Published public var sheet: NavigationNode?
    
    public init() {}
    
    public func handle(_ route: NavigationNode) {
        switch route {
        case .filterTagCollection:
            navigationPath.append(route)
        default:
            break
        }
    }
    
    public func view() -> some View {
        FilterView(coordinator: self)
    }
}

// Sources/Filter/Presentation/FilterView.swift


public struct FilterView: View {
    @ObservedObject var coordinator: FilterCoordinator
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        NavigationView {
            VStack {
                Text("Filter")
                    .font(.title)
                
                Button("Show Tag Collection") {
                    coordinator.handle(.filterTagCollection)
                }
                
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
}

// Sources/Filter/Presentation/FilterTagCollectionCoordinator.swift


public class FilterTagCollectionCoordinator: ObservableObject, Coordinator {
    @Published public var navigationPath = NavigationPath()
    @Published public var sheet: NavigationNode?
    
    public init() {}
    
    public func handle(_ route: NavigationNode) {
        switch route {
        case .filter:
            sheet = route
        default:
            break
        }
    }
    
    public func view() -> some View {
        FilterTagCollectionView(coordinator: self)
    }
}

// Sources/Filter/Presentation/FilterTagCollectionView.swift


public struct FilterTagCollectionView: View {
    @ObservedObject var coordinator: FilterTagCollectionCoordinator
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        VStack {
            Text("Filter Tag Collection")
                .font(.title)
            
            Button("Show Another Filter") {
                coordinator.handle(.filter)
            }
            
            Button("Close") {
                dismiss()
            }
        }
    }
}

// Sources/AppCore/AppCoordinator.swift


@MainActor
public class AppCoordinator: ObservableObject {
    @Published var homeCoordinator: HomeCoordinator
    
    public init() {
        self.homeCoordinator = HomeCoordinator()
    }
    
    public func start() -> some View {
        NavigationStack(path: $homeCoordinator.navigationPath) {
            homeCoordinator.view()
                .navigationDestination(for: NavigationNode.self) { node in
                    switch node {
                    case .category:
                        CategoryCoordinator().view()
                    case let .articleDetail(articleId):
                        ArticleCoordinator(articleId: articleId).view()
                    case .filter:
                        FilterCoordinator().view()
                    case .filterTagCollection:
                        FilterTagCollectionCoordinator().view()
                    }
                }
        }
    }
}

// Main App Entry Point
@main
struct NavigationDemoApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.start()
        }
    }
}
