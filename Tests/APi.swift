//
//  APi.swift
//  NavigationKit
//
//  Created by Anand on 2/4/25.
//

// MARK: - API Response States
enum APIState<T> {
    case loading
    case success(T)
    case error(Error)
    case empty
}

// MARK: - View Model
@MainActor
class BenefitsViewModel: ObservableObject {
    @Published private(set) var dentalState: APIState<BenefitCardData> = .loading
    @Published private(set) var medicalState: APIState<BenefitCardData> = .loading
    @Published private(set) var wellnessState: APIState<BenefitCardData> = .loading
    
    func loadData() async {
        // Load dental benefits
        do {
            // Simulate API call
            try await Task.sleep(nanoseconds: 2_000_000_000)
            let dentalData = BenefitCardData(
                icon: .dental,
                title: "Dental Benefits",
                subtitle: "Your plan includes dental coverage",
                supportText: "View details"
            )
            dentalState = .success(dentalData)
        } catch {
            dentalState = .error(error)
        }
        
        // Load medical benefits
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let medicalData = BenefitCardData(
                icon: .medical,
                title: "Medical Benefits",
                subtitle: "Review your coverage",
                supportText: "Learn more"
            )
            medicalState = .success(medicalData)
        } catch {
            medicalState = .error(error)
        }
        
        // Load wellness (simulating empty state)
        wellnessState = .empty
    }
}

// MARK: - Main View
struct BenefitsListView: View {
    @StateObject private var viewModel = BenefitsViewModel()
    private let coordinator: BenefitCoordinator
    
    init(coordinator: BenefitCoordinator) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Dental Benefits Section
                switch viewModel.dentalState {
                case .loading:
                    LoadingView()
                case .success(let data):
                    BenefitCardView(data: data, delegate: coordinator)
                case .error(let error):
                    ErrorView(error: error, retryAction: loadData)
                case .empty:
                    EmptyView()
                }
                
                // Medical Benefits Section
                switch viewModel.medicalState {
                case .loading:
                    LoadingView()
                case .success(let data):
                    BenefitCardView(data: data, delegate: coordinator)
                case .error(let error):
                    ErrorView(error: error, retryAction: loadData)
                case .empty:
                    EmptyView()
                }
                
                // Wellness Section (if available)
                if case .success(let data) = viewModel.wellnessState {
                    BenefitCardView(data: data, delegate: coordinator)
                }
            }
            .padding()
        }
        .task {
            await loadData()
        }
    }
    
    private func loadData() {
        Task {
            await viewModel.loadData()
        }
    }
}

// MARK: - Helper Views
struct LoadingView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Spacer()
        }
        .frame(height: 120)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 24))
                .foregroundColor(.red)
            
            Text("Unable to load benefits")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                retryAction()
            }
            .foregroundColor(.blue)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 24))
                .foregroundColor(.gray)
            
            Text("No benefits available")
                .font(.headline)
            
            Text("Check back later for updates")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

// MARK: - Usage Example
struct ContentView: View {
    let coordinator = BenefitCoordinator()
    
    var body: some View {
        BenefitsListView(coordinator: coordinator)
    }
}
