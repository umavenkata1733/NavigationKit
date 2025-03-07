
import SwiftUI

// Domain/Models/BenefitModels.swift

import Foundation

/// Main model representing the entire benefit summary section
public struct BenefitSummary {
    /// Header information for the benefit summary
    public let header: BenefitHeader
    
    /// Plan details section
    public let plan: PlanDetails
    
    /// Services section with commonly used services
    public let services: ServicesDetails
    
    public init(
        header: BenefitHeader,
        plan: PlanDetails,
        services: ServicesDetails
    ) {
        self.header = header
        self.plan = plan
        self.services = services
    }
}

/// Represents the header section of the benefit summary
public struct BenefitHeader {
    /// Main title displayed at the top
    public let title: String
    
    public init(title: String) {
        self.title = title
    }
}

/// Contains information about the plan details section
public struct PlanDetails {
    /// Title of the plan section
    public let title: String
    
    /// Description text explaining the plan
    public let description: String
    
    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

/// Represents the commonly used services section
public struct ServicesDetails {
    /// Title of the services section
    public let title: String
    
    /// Description text for the services section
    public let description: String
    
    /// Array of available services
    public let services: [ServiceItem]
    
    public init(
        title: String,
        description: String = "Review benefits details covered under your plan.",
        services: [ServiceItem]
    ) {
        self.title = title
        self.description = description
        self.services = services
    }
}

/// Individual service item model
public struct ServiceItem: Hashable {
    /// Unique identifier for the service
    public let id: String
    
    /// Display title for the service
    public let title: String
    
    public init(id: String = UUID().uuidString, title: String) {
        self.id = id
        self.title = title
    }
}

// Domain/Protocols/BenefitActions.swift

import Foundation

/// Protocol defining possible actions in the benefits summary view
public protocol BenefitSummaryActionDelegate: AnyObject {
    /// Called when user selects the plan section
    /// - Parameter title: Title of the selected plan
    func didSelectPlan(title: String)
    
    /// Called when user selects a specific service
    /// - Parameter title: Title of the selected service
    func didSelectService(title: String)
}


// Presentation/ViewModels/BenefitSummaryViewModel.swift

import SwiftUI

/// ViewModel managing the state and actions for the benefit summary view
@MainActor
public final class BenefitSummaryViewModel: ObservableObject {
    /// Published benefit summary data
    @Published private(set) var summary: BenefitSummary
    
    /// Weak reference to the action delegate
    private weak var delegate: BenefitSummaryActionDelegate?
    
    public init(summary: BenefitSummary, delegate: BenefitSummaryActionDelegate?) {
        self.summary = summary
        self.delegate = delegate
    }
    
    /// Handles selection of the plan section
    func handlePlanSelection() {
        delegate?.didSelectPlan(title: summary.plan.title)
    }
    
    /// Handles selection of a service item
    /// - Parameter service: The selected service item
    func handleServiceSelection(_ service: ServiceItem) {
        delegate?.didSelectService(title: service.title)
    }
}

// Presentation/Views/Components/UnderstandYourPlanSection.swift

import SwiftUI

/// View component for the plan understanding section
struct UnderstandYourPlanSection: View {
    let title: String
    let description: String
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 8)
        }
    }
}

// Presentation/Views/Components/ServiceItemView.swift

import SwiftUI

/// View component representing a single service item
struct ServiceItemView: View {
    let service: ServiceItem
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            Text(service.title)
                .font(.subheadline)
                .foregroundColor(.blue)
                .lineLimit(1)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue.opacity(0.02))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                )
        }
    }
}

// Presentation/Views/Components/CommonlyUsedServicesSection.swift

import SwiftUI

/// View component for the commonly used services section
struct CommonlyUsedServicesSection: View {
    let title: String
    let description: String
    let services: [ServiceItem]
    let onSelect: (ServiceItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(services, id: \.id) { service in
                    ServiceItemView(
                        service: service,
                        onSelect: { onSelect(service) }
                    )
                }
            }
        }
        .padding(.top, 8)
    }
}

// Presentation/Views/BenefitSummaryView.swift

import SwiftUI

/// Main view for displaying the benefit summary
public struct BenefitSummaryView: View {
    @StateObject private var viewModel: BenefitSummaryViewModel
    
    public init(viewModel: BenefitSummaryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection
            contentSection
        }
        .background(Color.clear)
    }
    
    private var headerSection: some View {
        Text(viewModel.summary.header.title)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .padding(.bottom, 16)
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            UnderstandYourPlanSection(
                title: viewModel.summary.plan.title,
                description: viewModel.summary.plan.description,
                onSelect: viewModel.handlePlanSelection
            )
            
            Divider()
                .padding(.vertical, 8)
            
            CommonlyUsedServicesSection(
                title: viewModel.summary.services.title,
                description: viewModel.summary.services.description,
                services: viewModel.summary.services.services,
                onSelect: viewModel.handleServiceSelection
            )
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

// Example/BenefitsUsageExample.swift

import SwiftUI

/// Example coordinator showing how to implement the delegate
class BenefitsCoordinator: BenefitSummaryActionDelegate {
    func didSelectPlan(title: String) {
        // Handle plan selection navigation
        print("Selected plan: \(title)")
    }
    
    func didSelectService(title: String) {
        // Handle service selection navigation
        print("Selected service: \(title)")
    }
}

/// Example view showing how to use the benefits summary
struct BenefitsExampleView: View {
    let coordinator = BenefitsCoordinator()
    
    var body: some View {
        // Create sample data
        let summary = BenefitSummary(
            header: BenefitHeader(title: "Understand Your Plan"),
            plan: PlanDetails(
                title: "Your Plan Summary",
                description: "Learn about your coverage and costs."
            ),
            services: ServicesDetails(
                title: "Commonly Used Services",
                services: [
                    ServiceItem(title: "Doctor visits"),
                    ServiceItem(title: "Lab work"),
                    ServiceItem(title: "X-rays"),
                    ServiceItem(title: "Prescriptions")
                ]
            )
        )
        
        // Create and return view
        BenefitSummaryView(
            viewModel: BenefitSummaryViewModel(
                summary: summary,
                delegate: coordinator
            )
        )
    }
}


//Test cases

// Tests/BenefitsKitTests/Domain/Models/BenefitModelsTests.swift

import XCTest
@testable import BenefitsKit

class BenefitModelsTests: XCTestCase {
    func testBenefitSummaryInitialization() {
        // Given
        let header = BenefitHeader(title: "Test Header")
        let plan = PlanDetails(title: "Test Plan", description: "Test Description")
        let services = ServicesDetails(
            title: "Test Services",
            services: [ServiceItem(title: "Test Service")]
        )
        
        // When
        let summary = BenefitSummary(header: header, plan: plan, services: services)
        
        // Then
        XCTAssertEqual(summary.header.title, "Test Header")
        XCTAssertEqual(summary.plan.title, "Test Plan")
        XCTAssertEqual(summary.services.services.count, 1)
        XCTAssertEqual(summary.services.services.first?.title, "Test Service")
    }
    
    func testServiceItemHashable() {
        // Given
        let serviceA = ServiceItem(id: "1", title: "Service A")
        let serviceB = ServiceItem(id: "1", title: "Service A")
        let serviceC = ServiceItem(id: "2", title: "Service A")
        
        // Then
        XCTAssertEqual(serviceA, serviceB)
        XCTAssertNotEqual(serviceA, serviceC)
        
        // Test hash set behavior
        let serviceSet = Set([serviceA, serviceB, serviceC])
        XCTAssertEqual(serviceSet.count, 2)
    }
}

// Tests/BenefitsKitTests/Presentation/ViewModels/BenefitSummaryViewModelTests.swift

import XCTest
@testable import BenefitsKit

class MockBenefitDelegate: BenefitSummaryActionDelegate {
    var planSelectedTitle: String?
    var serviceSelectedTitle: String?
    
    func didSelectPlan(title: String) {
        planSelectedTitle = title
    }
    
    func didSelectService(title: String) {
        serviceSelectedTitle = title
    }
}

class BenefitSummaryViewModelTests: XCTestCase {
    var sut: BenefitSummaryViewModel!
    var mockDelegate: MockBenefitDelegate!
    
    override func setUp() {
        super.setUp()
        mockDelegate = MockBenefitDelegate()
        
        let summary = BenefitSummary(
            header: BenefitHeader(title: "Test Header"),
            plan: PlanDetails(title: "Test Plan", description: "Test Description"),
            services: ServicesDetails(
                title: "Test Services",
                services: [ServiceItem(title: "Test Service")]
            )
        )
        
        sut = BenefitSummaryViewModel(summary: summary, delegate: mockDelegate)
    }
    
    override func tearDown() {
        sut = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testHandlePlanSelection() {
        // When
        sut.handlePlanSelection()
        
        // Then
        XCTAssertEqual(mockDelegate.planSelectedTitle, "Test Plan")
    }
    
    func testHandleServiceSelection() {
        // Given
        let service = ServiceItem(title: "Test Service")
        
        // When
        sut.handleServiceSelection(service)
        
        // Then
        XCTAssertEqual(mockDelegate.serviceSelectedTitle, "Test Service")
    }
}

// Tests/BenefitsKitTests/Presentation/Views/BenefitSummaryViewUITests.swift

import XCTest
import SwiftUI
import ViewInspector
@testable import BenefitsKit

extension BenefitSummaryView: Inspectable { }
extension UnderstandYourPlanSection: Inspectable { }
extension CommonlyUsedServicesSection: Inspectable { }
extension ServiceItemView: Inspectable { }

class BenefitSummaryViewUITests: XCTestCase {
    var sut: BenefitSummaryView!
    var mockDelegate: MockBenefitDelegate!
    
    override func setUp() {
        super.setUp()
        mockDelegate = MockBenefitDelegate()
        
        let summary = BenefitSummary(
            header: BenefitHeader(title: "Test Header"),
            plan: PlanDetails(title: "Test Plan", description: "Test Description"),
            services: ServicesDetails(
                title: "Test Services",
                services: [
                    ServiceItem(title: "Service 1"),
                    ServiceItem(title: "Service 2")
                ]
            )
        )
        
        let viewModel = BenefitSummaryViewModel(summary: summary, delegate: mockDelegate)
        sut = BenefitSummaryView(viewModel: viewModel)
    }
    
    func testHeaderDisplaysCorrectly() throws {
        let header = try sut.inspect().find(text: "Test Header")
        XCTAssertNotNil(header)
    }
    
    func testPlanSectionDisplaysCorrectly() throws {
        let planTitle = try sut.inspect().find(text: "Test Plan")
        let planDescription = try sut.inspect().find(text: "Test Description")
        
        XCTAssertNotNil(planTitle)
        XCTAssertNotNil(planDescription)
    }
    
    func testServicesDisplayCorrectly() throws {
        let service1 = try sut.inspect().find(text: "Service 1")
        let service2 = try sut.inspect().find(text: "Service 2")
        
        XCTAssertNotNil(service1)
        XCTAssertNotNil(service2)
    }
    
    func testPlanSelectionTriggersDelegate() throws {
        // When
        try sut.inspect().find(UnderstandYourPlanSection.self).button().tap()
        
        // Then
        XCTAssertEqual(mockDelegate.planSelectedTitle, "Test Plan")
    }
    
    func testServiceSelectionTriggersDelegate() throws {
        // When
        try sut.inspect().find(ServiceItemView.self).button().tap()
        
        // Then
        XCTAssertEqual(mockDelegate.serviceSelectedTitle, "Service 1")
    }
}

// Package.swift updates for testing dependencies

//// Add ViewInspector dependency
//dependencies: [
//    .package(url: "https://github.com/nalexn/ViewInspector", from: "0.9.0")
//]
//
//// Add dependency to test target
//targets: [
//    .testTarget(
//        name: "BenefitsKitTests",
//        dependencies: [
//            "BenefitsKit",
//            "ViewInspector"
//        ]
//    )
//]
