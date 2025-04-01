
import SwiftUI

// Common reusable component for all title-detail pairs
struct MedicalBannerTitleView: View {
    let title: String
    let detail: String
    var style: BannerTitleStyle = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            AdaptiveText(title,
                         config: .headline,
                         color: .secondary)
            AdaptiveText(detail,
                         config: .subheadline,
                         color: .black)
        }
    }
}

struct BannerTitleStyle {
    static let `default` = BannerTitleStyle()
}

struct MedicalPlanView: View {
    let plan: MedicalPlan
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Understand Your Plan")
                .font(.title2)
                .fontWeight(.medium)
                .padding(EdgePadding(leading: 20))

            VStack(alignment: .leading, spacing: 20) {
                // Medical Plan Header
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 30))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        
                        AdaptiveText("Medical Plan",
                                     config: .headline,
                                     color: .secondary)
                        
                        AdaptiveText(plan.medicalPlan,
                                     config: .headline,
                                     color: .primary)
                    }
                }
                
                // Status Badge
                HStack {
                    
                    AdaptiveText("Status: \(plan.status)",
                                 config: .headline,
                                 color: .primary)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                    Spacer()
                }
                
                // Generate all information fields from plan data
                ForEach(plan.getInfoFields(), id: \.title) { field in
                    MedicalBannerTitleView(
                        title: field.title,
                        detail: field.detail
                    )
                }
            }
            .padding(EdgePadding(all: 20))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))

        }
        .padding(EdgePadding(all: 16))
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
    }
}

// Data structure for info fields
struct InfoField {
    let title: String
    let detail: String
}

// Model
struct MedicalPlan: Codable {
    let medicalPlan: String
    let status: String
    let medicalRecordNumber: String
    let coverageStartDate: String
    let region: String
    let coveredPerson: String
    
    // Dynamically generate info fields
    func getInfoFields() -> [InfoField] {
        return [
            InfoField(title: "Medical Record Number", detail: medicalRecordNumber),
            InfoField(title: "Coverage Start Date", detail: coverageStartDate),
            InfoField(title: "Region", detail: region),
            InfoField(title: "Who's Covered", detail: coveredPerson)
        ]
    }
    
    // For dynamic JSON data
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.medicalPlan = try container.decode(String.self, forKey: .medicalPlan)
        self.status = try container.decode(String.self, forKey: .status)
        self.medicalRecordNumber = try container.decode(String.self, forKey: .medicalRecordNumber)
        self.coverageStartDate = try container.decode(String.self, forKey: .coverageStartDate)
        self.region = try container.decode(String.self, forKey: .region)
        self.coveredPerson = try container.decode(String.self, forKey: .coveredPerson)
    }
    
    // For static predefined data
    init(medicalPlan: String, status: String, medicalRecordNumber: String,
         coverageStartDate: String, region: String, coveredPerson: String) {
        self.medicalPlan = medicalPlan
        self.status = status
        self.medicalRecordNumber = medicalRecordNumber
        self.coverageStartDate = coverageStartDate
        self.region = region
        self.coveredPerson = coveredPerson
    }
}

// Data Provider that handles both static and dynamic JSON data
public class PlanDataProvider {
    // Sample static data
    static let samplePlan = MedicalPlan(
        medicalPlan: "[KP HMO Plan Name]",
        status: "Active 1",
        medicalRecordNumber: "123456",
        coverageStartDate: "01/01/2023",
        region: "Southern California",
        coveredPerson: "Eric Martinez"
    )
    
    // Get plan data from static JSON string
    public static func getSamplePlanJSON() -> String {
        return """
        {
            "medicalPlan": "[KP HMO Plan Name]",
            "status": "Active 1",
            "medicalRecordNumber": "123456",
            "coverageStartDate": "01/01/2023",
            "region": "Southern California",
            "coveredPerson": "Eric Martinez"
        }
        """
    }
    
    // Load from static JSON string
    static func loadMedicalPlanFromString() -> MedicalPlan? {
        let jsonString = getSamplePlanJSON()
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        
        do {
            return try JSONDecoder().decode(MedicalPlan.self, from: jsonData)
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    // Load from dynamic JSON data
    static func loadMedicalPlan(from jsonData: Data) -> MedicalPlan? {
        do {
            return try JSONDecoder().decode(MedicalPlan.self, from: jsonData)
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    // Get plan - prioritizes dynamic data if available, falls back to static
    static func getPlan(dynamicData: Data? = nil) -> MedicalPlan {
        if let data = dynamicData, let plan = loadMedicalPlan(from: data) {
            return plan
        } else if let plan = loadMedicalPlanFromString() {
            return plan
        } else {
            return samplePlan // Fallback to hardcoded sample
        }
    }
}
