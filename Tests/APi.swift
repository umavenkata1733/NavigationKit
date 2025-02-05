import SwiftUI

// MARK: - Benefit Type
public enum BenefitType: String, CaseIterable {
    case dental, medical
}

// MARK: - Benefit Data Model
public struct BenefitCardData: Identifiable {
    public let id = UUID()
    public let icon: BenefitIcon
    public let title: String
    public let subtitle: String
    public let supportText: String
    
    public init(
        icon: BenefitIcon,
        title: String,
        subtitle: String,
        supportText: String
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.supportText = supportText
    }
}

// MARK: - Benefit Icon
public enum BenefitIcon {
    case dental
    case medical
    case custom(icon: String)
    
    var iconName: String {
        switch self {
        case .dental: return "tooth.circle"
        case .medical: return "cross.case.fill"
        case .custom(let icon): return icon
        }
    }
}

// MARK: - API States
enum APIState<T> {
    case loading
    case success(T)
    case error(Error)
    case empty
}


@MainActor
class MedicalBenefitsViewModel: ObservableObject {
    @Published private(set) var medicalState: APIState<BenefitCardData> = .loading

    func loadData() async {
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            let medicalData = BenefitCardData(
                icon: .medical,
                title: "Medical Benefits",
                subtitle: "Review your medical coverage",
                supportText: "Learn more"
            )
            medicalState = .success(medicalData)
        } catch {
            medicalState = .error(error)
        }
    }
}

@MainActor
class DentalBenefitsViewModel: ObservableObject {
    @Published private(set) var dentalState: APIState<BenefitCardData> = .loading

    func loadData() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let dentalData = BenefitCardData(
                icon: .dental,
                title: "Dental Benefits",
                subtitle: "Covers cleanings and checkups",
                supportText: "View details"
            )
            dentalState = .success(dentalData)
        } catch {
            dentalState = .error(error)
        }
    }
}

// MARK: - Medical Benefits View
public struct MedicalBenefitCardView: View {
    private let data: BenefitCardData
    private weak var delegate: BenefitCardDelegate?
    
    public init(data: BenefitCardData, delegate: BenefitCardDelegate?) {
        self.data = data
        self.delegate = delegate
    }
    
    public var body: some View {
        Button(action: { delegate?.didTapBenefitCard(data) }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 16) {
                    Image(systemName: data.icon.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text(data.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(data.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                Text(data.supportText)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 1)
        }
    }
}

// MARK: - Dental Benefits View
public struct DentalBenefitCardView: View {
    private let data: BenefitCardData
    private weak var delegate: BenefitCardDelegate?
    
    public init(data: BenefitCardData, delegate: BenefitCardDelegate?) {
        self.data = data
        self.delegate = delegate
    }
    
    public var body: some View {
        Button(action: { delegate?.didTapBenefitCard(data) }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 16) {
                    Image(systemName: data.icon.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading) {
                        Text(data.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(data.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                Text(data.supportText)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 1)
        }
    }
}


struct BenefitsListView: View {
    @StateObject private var medicalViewModel = MedicalBenefitsViewModel()
    @StateObject private var dentalViewModel = DentalBenefitsViewModel()
    private let coordinator: BenefitCoordinator

    init(coordinator: BenefitCoordinator) {
        self.coordinator = coordinator
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                medicalSection
                dentalSection
            }
            .padding()
        }
        .task {
            await loadData()
        }
    }
    
    private var medicalSection: some View {
        Group {
            switch medicalViewModel.medicalState {
            case .loading:
                LoadingView()
            case .success(let data):
                MedicalBenefitCardView(data: data, delegate: coordinator)
            case .error(let error):
                ErrorView(error: error, retryAction: { reloadMedical() })
            case .empty:
                EmptyStateView()
            }
        }
    }
    
    private var dentalSection: some View {
        Group {
            switch dentalViewModel.dentalState {
            case .loading:
                LoadingView()
            case .success(let data):
                DentalBenefitCardView(data: data, delegate: coordinator)
            case .error(let error):
                ErrorView(error: error, retryAction: { reloadDental() })
            case .empty:
                EmptyStateView()
            }
        }
    }

    private func loadData() async {
        async let medicalLoad = medicalViewModel.loadData()
        async let dentalLoad = dentalViewModel.loadData()
        await (medicalLoad, dentalLoad)
    }

    private func reloadMedical() {
        Task { await medicalViewModel.loadData() }
    }

    private func reloadDental() {
        Task { await dentalViewModel.loadData() }
    }
}


class BenefitCoordinator: BenefitCardDelegate {
    func didTapBenefitCard(_ data: BenefitCardData) {
        print("Tapped benefit: \(data.title)")
    }
}


struct ContentView: View {
    let coordinator = BenefitCoordinator()
    
    var body: some View {
        BenefitsListView(coordinator: coordinator)
    }
}




/*
 // MARK: - Repository Protocol
 protocol BenefitsRepository {
     func fetchMedicalBenefits() async throws -> BenefitCardData
     func fetchDentalBenefits() async throws -> BenefitCardData
 }

 // MARK: - Mock Repository Implementation
 final class MockBenefitsRepository: BenefitsRepository {
     func fetchMedicalBenefits() async throws -> BenefitCardData {
         // Simulate network delay
         try await Task.sleep(nanoseconds: 1_000_000_000)
         return BenefitCardData(
             icon: .medical,
             title: "Medical Benefits",
             subtitle: "Review your medical coverage",
             supportText: "Learn more"
         )
     }
     
     func fetchDentalBenefits() async throws -> BenefitCardData {
         try await Task.sleep(nanoseconds: 1_000_000_000)
         return BenefitCardData(
             icon: .dental,
             title: "Dental Benefits",
             subtitle: "Covers cleanings and checkups",
             supportText: "View details"
         )
     }
 }

 // MARK: - Network Repository Implementation
 final class NetworkBenefitsRepository: BenefitsRepository {
     private let networkClient: NetworkClient
     
     init(networkClient: NetworkClient) {
         self.networkClient = networkClient
     }
     
     func fetchMedicalBenefits() async throws -> BenefitCardData {
         let endpoint = BenefitsEndpoint.medical
         return try await networkClient.request(endpoint)
     }
     
     func fetchDentalBenefits() async throws -> BenefitCardData {
         let endpoint = BenefitsEndpoint.dental
         return try await networkClient.request(endpoint)
     }
 }

 // MARK: - Use Cases
 protocol BenefitsUseCase {
     func getMedicalBenefits() async throws -> BenefitCardData
     func getDentalBenefits() async throws -> BenefitCardData
 }

 final class DefaultBenefitsUseCase: BenefitsUseCase {
     private let repository: BenefitsRepository
     
     init(repository: BenefitsRepository) {
         self.repository = repository
     }
     
     func getMedicalBenefits() async throws -> BenefitCardData {
         return try await repository.fetchMedicalBenefits()
     }
     
     func getDentalBenefits() async throws -> BenefitCardData {
         return try await repository.fetchDentalBenefits()
     }
 }

 // MARK: - Network Client (To be implemented)
 protocol NetworkClient {
     func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
 }

 protocol Endpoint {
     var path: String { get }
     var method: HTTPMethod { get }
 }

 enum HTTPMethod: String {
     case get = "GET"
     case post = "POST"
 }

 enum BenefitsEndpoint: Endpoint {
     case medical
     case dental
     
     var path: String {
         switch self {
         case .medical:
             return "/api/benefits/medical"
         case .dental:
             return "/api/benefits/dental"
         }
     }
     
     var method: HTTPMethod {
         .get
     }
 }

 // MARK: - View Model Implementation using Use Case
 @MainActor
 final class BenefitsViewModel: ObservableObject {
     @Published private(set) var medicalState: APIState<BenefitCardData> = .loading
     @Published private(set) var dentalState: APIState<BenefitCardData> = .loading
     
     private let useCase: BenefitsUseCase
     
     init(useCase: BenefitsUseCase) {
         self.useCase = useCase
     }
     
     func loadMedicalBenefits() async {
         do {
             let data = try await useCase.getMedicalBenefits()
             medicalState = .success(data)
         } catch {
             medicalState = .error(error)
         }
     }
     
     func loadDentalBenefits() async {
         do {
             let data = try await useCase.getDentalBenefits()
             dentalState = .success(data)
         } catch {
             dentalState = .error(error)
         }
     }
 }

 // MARK: - Example Usage
 struct ExampleUsage {
     static func setupWithMockData() -> BenefitsViewModel {
         let repository = MockBenefitsRepository()
         let useCase = DefaultBenefitsUseCase(repository: repository)
         return BenefitsViewModel(useCase: useCase)
     }
     
     static func setupWithNetworkData(networkClient: NetworkClient) -> BenefitsViewModel {
         let repository = NetworkBenefitsRepository(networkClient: networkClient)
         let useCase = DefaultBenefitsUseCase(repository: repository)
         return BenefitsViewModel(useCase: useCase)
     }
 }

 // MARK: - View Implementation
 struct BenefitsView: View {
     @StateObject private var viewModel: BenefitsViewModel
     
     init(useCase: BenefitsUseCase) {
         _viewModel = StateObject(wrappedValue: BenefitsViewModel(useCase: useCase))
     }
     
     var body: some View {
         ScrollView {
             VStack(spacing: 16) {
                 medicalSection
                 dentalSection
             }
             .padding()
         }
         .task {
             await loadData()
         }
     }
     
     private func loadData() async {
         await viewModel.loadMedicalBenefits()
         await viewModel.loadDentalBenefits()
     }
     
     private var medicalSection: some View {
         BenefitSectionView(state: viewModel.medicalState) { data in
             MedicalBenefitCardView(data: data)
         }
     }
     
     private var dentalSection: some View {
         BenefitSectionView(state: viewModel.dentalState) { data in
             DentalBenefitCardView(data: data)
         }
     }
 }

 // Example of how to use the view with different data sources
 struct ContentView: View {
     var body: some View {
         // With mock data
         BenefitsView(useCase: DefaultBenefitsUseCase(repository: MockBenefitsRepository()))
         
         // Later, with real network data
         // BenefitsView(useCase: DefaultBenefitsUseCase(repository: NetworkBenefitsRepository(networkClient: YourNetworkClient())))
     }
 }
 
 */
