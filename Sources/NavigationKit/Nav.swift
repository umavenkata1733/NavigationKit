//
//  Nav.swift
//  NavigationKit
//
//  Created by Anand on 1/14/25.
//

import SwiftUI
import Combine

public protocol NavigationNode: Hashable, Identifiable {
    var navigationId: String { get }
}

public extension NavigationNode {
    var id: String { navigationId }
}

/// A type-erased wrapper for NavigationNode to ensure Hashable conformance
public struct ErasedNavigationNode: Hashable {
    private let base: any NavigationNode
    private let hashValueClosure: () -> Int
    private let equalsClosure: (any NavigationNode) -> Bool
    
    public init(_ base: any NavigationNode) {
        self.base = base
        self.hashValueClosure = { base.hashValue }
        self.equalsClosure = { $0.navigationId == base.navigationId }
    }
    
    public func hash(into hasher: inout Hasher) {
        hashValueClosure().hash(into: &hasher)
    }
    
    public static func == (lhs: ErasedNavigationNode, rhs: ErasedNavigationNode) -> Bool {
        lhs.base.navigationId == rhs.base.navigationId
    }
}

/// A struct to wrap NavigationNode for sheet presentation
public struct SheetWrapper: Identifiable {
    public let id: String
    public let node: ErasedNavigationNode
    
    public init(node: any NavigationNode) {
        self.id = node.navigationId
        self.node = ErasedNavigationNode(node)
    }
}

@MainActor
public final class NavigationController: ObservableObject {
    @Published public var path: NavigationPath = NavigationPath()
    @Published public var presentedSheet: SheetWrapper?
    
    public weak var parent: NavigationController?
    @Published public var child: NavigationController?
    
    public init(parent: NavigationController? = nil) {
        self.parent = parent
    }
    
    public func navigate<T: NavigationNode>(to node: T) {
        path.append(ErasedNavigationNode(node))
    }
    
    public func present<T: NavigationNode>(_ node: T) {
        let childController = NavigationController(parent: self)
        child = childController
        presentedSheet = SheetWrapper(node: node)
    }
    
    public func popLast() {
        if !path.isEmpty {
            _ = path.removeLast()
        }
    }
    
    public func dismiss() {
        parent?.child = nil
        parent?.presentedSheet = nil
    }
}


public struct NavigationStackView<Root: View, Destination: View>: View {
    @ObservedObject private var controller: NavigationController
    private let root: Root
    private let destination: (ErasedNavigationNode) -> Destination

    public init(
        controller: NavigationController,
        @ViewBuilder root: () -> Root,
        @ViewBuilder destination: @escaping (ErasedNavigationNode) -> Destination
    ) {
        self.controller = controller
        self.root = root()
        self.destination = destination
    }

    public var body: some View {
        NavigationStack(path: $controller.path) {
            root
                .navigationDestination(for: ErasedNavigationNode.self) { node in
                    destination(node)
                }
        }
        .sheet(item: $controller.presentedSheet) { wrapper in
            if let childController = controller.child {
                NavigationStackView(
                    controller: childController,
                    root: { root }, // Pass the same root
                    destination: destination
                )
            }
        }
    }
}
