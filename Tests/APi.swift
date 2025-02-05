import SwiftUI
import CostServicesKit

class CostCoordinator: ObservableObject {
    @Published var showMedicalEstimator = false
    @Published var showDrugEstimator = false
    @Published var showIDCard = false
    
    func handle(_ action: CostServiceAction) {
        switch action {
        case .medicalEstimator:
            showMedicalEstimator = true
        case .drugEstimator:
            showDrugEstimator = true
        case .idCard:
            showIDCard = true
        case .showMore:
            break // Handled internally by the view
        }
    }
}

struct CostView: View {
    @StateObject private var coordinator = CostCoordinator()
    
    var body: some View {
        CostServicesView(
            viewModel: CostServicesViewModel(
                sections: [
                    // Cost Estimates Section
                    CostServiceSection(
                        type: .costEstimates,
                        cells: [
                            CostServiceCell(
                                icon: "dollarsign.square",
                                title: "Medical Cost Estimator",
                                subtitle: "Get a cost estimate for medical services.",
                                action: .medicalEstimator
                            ),
                            CostServiceCell(
                                icon: "pill",
                                title: "Drug Cost Estimator",
                                subtitle: "Get a drug cost estimate.",
                                action: .drugEstimator
                            )
                        ]
                    ),
                    // ID Card Section
                    CostServiceSection(
                        type: .idCard,
                        cells: [
                            CostServiceCell(
                                icon: "creditcard",
                                title: "ID Card Help",
                                subtitle: "Order member ID cards",
                                action: .idCard
                            )
                        ]
                    )
                ],
                onAction: coordinator.handle(_:)
            )
        )
        .sheet(isPresented: $coordinator.showMedicalEstimator) {
            // Your Medical Estimator View
            Text("Medical Estimator")
        }
        .sheet(isPresented: $coordinator.showDrugEstimator) {
            // Your Drug Estimator View
            Text("Drug Estimator")
        }
        .sheet(isPresented: $coordinator.showIDCard) {
            // Your ID Card View
            Text("ID Card")
        }
        .padding(10)
    }
}

