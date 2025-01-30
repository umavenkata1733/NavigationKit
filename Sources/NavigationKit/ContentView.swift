//
//  ContentView.swift
//  DemoBenefitsApp
//
//  Created by Anand on 1/30/25.
//

import SwiftUI
import CoreData
import BenefitsKit


struct ContentView: View {
    var body: some View {
        NavigationView {
            BenefitsRootView()
        }
    }
}

struct BenefitsRootView: View {
    @StateObject private var navigationState = NavigationState()
    
    let sampleBenefits: [BenefitsDataModel] = [
        .init(
            id: "health-2024",
            name: "Health Coverage",
            description: "Comprehensive health insurance",
            coverageAmount: 5000.00, webUrl: ""
        ),
        .init(
            id: "dental-2024",
            name: "Dental Care",
            description: "Basic dental coverage",
            coverageAmount: 1000.00, webUrl: ""
        )
    ]
    
    var body: some View {
        BenefitsView(configuration: BenefitsConfiguration(
            initialBenefits: sampleBenefits,
            onBenefitSelected: { benefit in
                if let url = BenefitURLHandler.getURL(for: benefit.id) {
                    navigationState.selectedURL = url
                    navigationState.selectedTitle = benefit.name
                    navigationState.showWebView = true
                }
            }
        ))
        .fullScreenCover(isPresented: $navigationState.showWebView) {
            if let url = navigationState.selectedURL {
                WebViewContainer(
                    url: url,
                    title: navigationState.selectedTitle,
                    isPresented: $navigationState.showWebView
                )
            }
        }
    }
}

// DemoProject/State/NavigationState.swift
class NavigationState: ObservableObject {
    @Published var showWebView = false
    @Published var selectedURL: URL?
    @Published var selectedTitle = ""
}

// DemoProject/Views/WebViewContainer.swift
struct WebViewContainer: View {
    let url: URL
    let title: String
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            BenefitsWebView(url: url)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            isPresented = false
                        }
                    }
                }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
