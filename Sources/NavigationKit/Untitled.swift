//
//  Untitled.swift
//  NavigationKit
//
//  Created by Anand on 1/14/25.


import Combine
import Foundation
import SwiftUI

public final class NavigationStore: ObservableObject {
    @Published public var rootNode: AnyHashable
    @Published public var navigationPath: [AnyHashable] = []
    @Published public var childSheetNavigationStore: NavigationStore?
    
    public weak var parentNavigationStore: NavigationStore?

    public init(
        rootNode: AnyHashable,
        parentNavigationStore: NavigationStore?
    ) {
        self.rootNode = rootNode
        self.parentNavigationStore = parentNavigationStore
    }
    
    public func openSheet(with node: AnyHashable) {
        childSheetNavigationStore = NavigationStore(
            rootNode: node,
            parentNavigationStore: self
        )
    }
    
    public func closeSheet() {
        parentNavigationStore?.childSheetNavigationStore = nil
    }
}


//  NavRootView.swift
//  NavigationFramework
//
//  Created by Anand on 1/14/25.
//

import SwiftUI

// In NavigationFramework SPM package
public struct NavRootView: View {
    @ObservedObject private var navigationStore: NavigationStore
    private let viewFactory: ViewFactory
    
    public init(navigationStore: NavigationStore, viewFactory: ViewFactory) {
        self.navigationStore = navigationStore
        self.viewFactory = viewFactory
    }
    
    public var body: some View {
        NavigationStack(path: $navigationStore.navigationPath) {
            viewFactory.getView(for: navigationStore.rootNode)
                .navigationDestination(for: AnyHashable.self) { node in
                    viewFactory.getView(for: node)
                }
        }
        .sheet(isPresented: .init(
            get: { navigationStore.childSheetNavigationStore != nil },
            set: { _ in navigationStore.childSheetNavigationStore = nil }
        )) {
            if let sheetNavigationStore = navigationStore.childSheetNavigationStore {
                NavRootView(
                    navigationStore: sheetNavigationStore,
                    viewFactory: viewFactory
                )
            }
        }
    }
    
    
}


@MainActor
open class ViewFactory {
    public init() {}
    @ViewBuilder
    open func getView(for node: AnyHashable) -> some View {
        Text("Override getView in your app's ViewFactory")
    }
}
