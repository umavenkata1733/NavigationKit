import SwiftUI

// Model for medical plan data
struct MedicalPlan {
    let planName: String
    let planType: String
    let coverageDates: CoverageDates
    let inNetwork: Coverage
    let participatingProvider: Coverage
    let outOfNetwork: Coverage
    
    struct CoverageDates {
        let startDate: Date
        let endDate: Date
        
        var formatted: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
        }
    }
    
    struct Coverage {
        let individual: Double
        let family: Double
        let deductible: Double?
        
        var formattedCosts: String {
            return "$\(individual.formatWithCommas()) individual / $\(family.formatWithCommas()) family"
        }
    }
}

// Extension to format currency
extension Double {
    func formatWithCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

struct MedicalPlanView: View {
    let plan: MedicalPlan
    
    init(plan: MedicalPlan? = nil) {
        // If no plan is provided, use sample data
        self.plan = plan ?? MedicalPlanView.samplePlan
    }
    
    // Sample plan data
    static var samplePlan: MedicalPlan {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2025, month: 1, day: 1)
        let endComponents = DateComponents(year: 2025, month: 12, day: 31)
        
        return MedicalPlan(
            planName: "Medical Plan",
            planType: "KP Standard Bronze",
            coverageDates: MedicalPlan.CoverageDates(
                startDate: calendar.date(from: startComponents) ?? Date(),
                endDate: calendar.date(from: endComponents) ?? Date()
            ),
            inNetwork: MedicalPlan.Coverage(
                individual: 3500,
                family: 9400,
                deductible: nil
            ),
            participatingProvider: MedicalPlan.Coverage(
                individual: 3500,
                family: 9400,
                deductible: nil
            ),
            outOfNetwork: MedicalPlan.Coverage(
                individual: 3500,
                family: 9400,
                deductible: nil
            )
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text(plan.planName)
                    .font(.largeTitle)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                
                // Plan Type
                Text(plan.planType)
                    .font(.title2)
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                
                // Coverage Dates Section
                VStack(alignment: .leading, spacing: 5) {
                    Text("Coverage Dates")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Text(plan.coverageDates.formatted)
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(.top, 2)
                }
                
                // In-Network Section
                CoverageSectionView(
                    title: "In-Network",
                    coverage: plan.inNetwork
                )
                
                // Participating Provider Section
                CoverageSectionView(
                    title: "Participating Provider",
                    coverage: plan.participatingProvider
                )
                
                // Out-of-Network Section
                CoverageSectionView(
                    title: "Out-of-Network",
                    coverage: plan.outOfNetwork
                )
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.systemGray6))
    }
}

// Reusable component for coverage sections
struct CoverageSectionView: View {
    let title: String
    let coverage: MedicalPlan.Coverage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Button(action: {
                    // Show info action here
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                }
            }
            
            Text(coverage.formattedCosts)
                .font(.title3)
                .foregroundColor(.black)
            
            Text(coverage.formattedCosts)
                .font(.title3)
                .foregroundColor(.black)
        }
    }
}

struct MedicalPlanView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Default sample data
            MedicalPlanView()
            
            // Custom plan example
            MedicalPlanView(plan: MedicalPlan(
                planName: "Medical Plan",
                planType: "Gold PPO Plus",
                coverageDates: MedicalPlan.CoverageDates(
                    startDate: Date(),
                    endDate: Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
                ),
                inNetwork: MedicalPlan.Coverage(
                    individual: 1500,
                    family: 4500,
                    deductible: 500
                ),
                participatingProvider: MedicalPlan.Coverage(
                    individual: 2000,
                    family: 6000,
                    deductible: 750
                ),
                outOfNetwork: MedicalPlan.Coverage(
                    individual: 5000,
                    family: 10000,
                    deductible: 1000
                )
            ))
        }
    }
}
