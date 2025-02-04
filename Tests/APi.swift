# Sources/BenefitsKit/Domain/Models/DentalBenefitModel.swift
struct DentalBenefitModel {
    let title: String
    let subtitle: String
    let isEnabled: Bool
}

# Sources/BenefitsKit/Domain/Models/MedicalBenefitModel.swift
struct MedicalBenefitModel {
    let title: String
    let coverage: String
    let isEnabled: Bool
}

# Sources/BenefitsKit/Domain/UseCases/FetchBenefitsUseCase.swift
protocol FetchBenefitsUseCase {
    func fetchDentalBenefits() async throws -> DentalBenefitModel
    func fetchMedicalBenefits() async throws -> MedicalBenefitModel
}

# Sources/BenefitsKit/Presentation/ViewModels/DentalBenefitsViewModel.swift
@MainActor
final class DentalBenefitsViewModel: ObservableObject {
    @Published private(set) var state: ViewState<DentalBenefitModel>?
    private let useCase: FetchBenefitsUseCase
    
    init(useCase: FetchBenefitsUseCase) {
        self.useCase = useCase
    }
    
    func loadBenefits() async {
        state = .loading
        do {
            let model = try await useCase.fetchDentalBenefits()
            state = .loaded(model)
        } catch {
            state = .error(error)
        }
    }
}

# Sources/BenefitsKit/Presentation/ViewModels/MedicalBenefitsViewModel.swift
@MainActor
final class MedicalBenefitsViewModel: ObservableObject {
    @Published private(set) var state: ViewState<MedicalBenefitModel>?
    private let useCase: FetchBenefitsUseCase
    
    init(useCase: FetchBenefitsUseCase) {
        self.useCase = useCase
    }
    
    func loadBenefits() async {
        state = .loading
        do {
            let model = try await useCase.fetchMedicalBenefits()
            state = .loaded(model)
        } catch {
            state = .error(error)
        }
    }
}

# Sources/BenefitsKit/Presentation/Views/DentalBenefits/DentalBenefitsView.swift
struct DentalBenefitsView: View {
    @ObservedObject var viewModel: DentalBenefitsViewModel
    
    var body: some View {
        ViewStateContainer(state: viewModel.state) { model in
            if model.isEnabled {
                DentalBenefitsContent(model: model)
            }
        }
    }
}

struct DentalBenefitsContent: View {
    let model: DentalBenefitModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .font(.headline)
            Text(model.subtitle)
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

# Sources/BenefitsKit/Presentation/Views/MedicalBenefits/MedicalBenefitsView.swift
struct MedicalBenefitsView: View {
    @ObservedObject var viewModel: MedicalBenefitsViewModel
    
    var body: some View {
        ViewStateContainer(state: viewModel.state) { model in
            if model.isEnabled {
                MedicalBenefitsContent(model: model)
            }
        }
    }
}

struct MedicalBenefitsContent: View {
    let model: MedicalBenefitModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .font(.headline)
            Text(model.coverage)
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

# Sources/BenefitsKit/Presentation/Views/Shared/ViewStateContainer.swift
struct ViewStateContainer<T, Content: View>: View {
    let state: ViewState<T>?
    let content: (T) -> Content
    
    var body: some View {
        if let state = state {
            switch state {
            case .loading:
                ProgressView()
            case .loaded(let model):
                content(model)
            case .error:
                EmptyView()
            }
        } else {
            EmptyView()
        }
    }
}

# Sources/BenefitsKit/Presentation/Views/BenefitsContainerView.swift
struct BenefitsContainerView: View {
    @StateObject private var dentalViewModel: DentalBenefitsViewModel
    @StateObject private var medicalViewModel: MedicalBenefitsViewModel
    
    init(useCase: FetchBenefitsUseCase) {
        _dentalViewModel = StateObject(wrappedValue: DentalBenefitsViewModel(useCase: useCase))
        _medicalViewModel = StateObject(wrappedValue: MedicalBenefitsViewModel(useCase: useCase))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            DentalBenefitsView(viewModel: dentalViewModel)
            MedicalBenefitsView(viewModel: medicalViewModel)
        }
        .task {
            await loadData()
        }
    }
    
    private func loadData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await dentalViewModel.loadBenefits() }
            group.addTask { await medicalViewModel.loadBenefits() }
        }
    }
}
