
// Sources/BenefitsKit/Models/BenefitsModels.swift
import Foundation
import Introspect

public struct BenefitsDataModel: Codable, Identifiable {
    public let id: String
    public let name: String
    public let description: String
    public let coverageAmount: Double
    
    public init(id: String, name: String, description: String, coverageAmount: Double, webUrl: String) {
        self.id = id
        self.name = name
        self.description = description
        self.coverageAmount = coverageAmount
    }
}

public struct BenefitsDomainModel: Identifiable {
    public let id: String
    public let name: String
    public let description: String
    public let formattedCoverage: String

    public init(data: BenefitsDataModel) {
        self.id = data.id
        self.name = data.name
        self.description = data.description
        self.formattedCoverage = "$\(data.coverageAmount)"
    }
}

// Sources/BenefitsKit/Common/Theme.swift
import SwiftUI

enum Theme {
    static let primaryColor = Color.blue
    static let backgroundColor = Color(.systemGroupedBackground)
    static let textColor = Color(.label)
    static let subtitleColor = Color(.secondaryLabel)
}

struct Constants {
    static let cornerRadius: CGFloat = 12
    static let padding: CGFloat = 16
}

// Sources/BenefitsKit/Protocols/BenefitsProtocols.swift
public protocol BenefitsRepository {
    func getBenefits() -> [BenefitsDataModel]
}

public protocol BenefitsUseCase {
    func getBenefits() -> [BenefitsDomainModel]
    func getBenefitURL(for id: String) -> URL?
}

public protocol BenefitsRouting: AnyObject {
    var onBenefitSelected: ((BenefitsDomainModel) -> Void)? { get set }
    func navigateToDetail(benefit: BenefitsDomainModel)
}

// Sources/BenefitsKit/Implementation/Repository.swift
public class MockBenefitsRepository: BenefitsRepository {
    private let benefits: [BenefitsDataModel]
    
    public init(benefits: [BenefitsDataModel]) {
        self.benefits = benefits
    }
    
    public func getBenefits() -> [BenefitsDataModel] {
        return benefits
    }
}

// Sources/BenefitsKit/Implementation/UseCase.swift
public class BenefitsUseCaseImpl: BenefitsUseCase {
    private let repository: BenefitsRepository
    
    public init(repository: BenefitsRepository) {
        self.repository = repository
    }
    
    public func getBenefits() -> [BenefitsDomainModel] {
        return repository.getBenefits().map { BenefitsDomainModel(data: $0) }
    }
    public func getBenefitURL(for id: String) -> URL? {
        return BenefitURLHandler.getURL(for: id)
    }
}

// Sources/BenefitsKit/Implementation/Router.swift
public class BenefitsRouter: BenefitsRouting {
    public var onBenefitSelected: ((BenefitsDomainModel) -> Void)?
    
    public init() {}
    
    public func navigateToDetail(benefit: BenefitsDomainModel) {
        onBenefitSelected?(benefit)
    }
}

// Sources/BenefitsKit/ViewModel/BenefitsViewModel.swift
import SwiftUI

class BenefitsViewModel: ObservableObject {
    @Published var benefits: [BenefitsDomainModel] = []
    
    private let useCase: BenefitsUseCase
    private let router: BenefitsRouting
    
    init(useCase: BenefitsUseCase, router: BenefitsRouting) {
        self.useCase = useCase
        self.router = router
        loadBenefits()
    }
    
    private func loadBenefits() {
        benefits = useCase.getBenefits()
    }
    
    func benefitSelected(_ benefit: BenefitsDomainModel) {
        router.navigateToDetail(benefit: benefit)
    }
    func getBenefitURL(for id: String) -> URL? {
        return useCase.getBenefitURL(for: id)
    }
}

// Sources/BenefitsKit/Views/BenefitCard.swift
import SwiftUI

struct BenefitCard: View {
    let benefit: BenefitsDomainModel
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Text(benefit.name)
                    .font(.headline)
                    .foregroundColor(Theme.textColor)
                
                Text(benefit.description)
                    .font(.subheadline)
                    .foregroundColor(Theme.subtitleColor)
                
                Text(benefit.formattedCoverage)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(Theme.primaryColor)
            }
            .padding(Constants.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(Constants.cornerRadius)
            .shadow(radius: 2)
        }
    }
}

// Sources/BenefitsKit/Views/BenefitDetailView.swift
import SwiftUI

struct BenefitDetailView: View {
    let benefit: BenefitsDomainModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text(benefit.name)
                    .font(.largeTitle)
                
                Text(benefit.description)
                    .font(.body)
                
                Text("Coverage Amount:")
                    .font(.headline)
                Text(benefit.formattedCoverage)
                    .font(.title)
                    .foregroundColor(Theme.primaryColor)
                
                Spacer()
            }
            .padding()
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
            .navigationTitle("Benefit Details")
        }
    }
}

// Sources/BenefitsKit/Configuration/BenefitsConfiguration.swift
public struct BenefitsConfiguration {
    public let initialBenefits: [BenefitsDataModel]
    public let onBenefitSelected: ((BenefitsDomainModel) -> Void)?
    
    public init(
        initialBenefits: [BenefitsDataModel],
        onBenefitSelected: ((BenefitsDomainModel) -> Void)? = nil
    ) {
        self.initialBenefits = initialBenefits
        self.onBenefitSelected = onBenefitSelected
    }
}

// Sources/BenefitsKit/Views/BenefitsView.swift
public struct BenefitsView: View {
    @StateObject private var viewModel: BenefitsViewModel
    @State private var selectedBenefit: BenefitsDomainModel?
    @State private var showingDetail = false
    
    public init(configuration: BenefitsConfiguration) {
        let repository = MockBenefitsRepository(benefits: configuration.initialBenefits)
        let useCase = BenefitsUseCaseImpl(repository: repository)
        let router = BenefitsRouter()
        router.onBenefitSelected = configuration.onBenefitSelected
        _viewModel = StateObject(wrappedValue: BenefitsViewModel(useCase: useCase, router: router))
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.benefits) { benefit in
                        BenefitCard(benefit: benefit) {
                            selectedBenefit = benefit
                            showingDetail = true
                            viewModel.benefitSelected(benefit)
                        }
                    }
                }
                .padding(Constants.padding)
            }
            .sheet(isPresented: $showingDetail) {
                if let benefit = selectedBenefit {
                    BenefitDetailView(benefit: benefit)
                }
            }
            .background(Theme.backgroundColor)
            .navigationTitle("Benefits")
            .introspectNavigationController { navController in
                 navController.navigationBar.prefersLargeTitles = false
                 navController.navigationBar.tintColor = UIColor.red
             }
        }
    }
}

public enum BenefitURLHandler {
    public static func getURL(for benefitId: String) -> URL? {
        let urlMap: [String: String] = [
            "health-2024": "https://healthy.kaiserpermanente.org/georgia/doctors-locations",
            "dental-2024": "https://healthy.kaiserpermanente.org/georgia/health-wellness",
            "vision-2024": "https://healthy.kaiserpermanente.org/georgia/get-care"
        ]
        return URL(string: urlMap[benefitId] ?? "")
    }
}
