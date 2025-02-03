
import SwiftUI


// Models/BenefitSummary.swift
public struct BenefitSummary {
    public let title: String
    public let titleHeader: String

    public let description: String
    public let commonlyUsedServicesTitle: String
    public let commonlyUsedServices: [String]
    
    public init(title: String, titleHeader: String, description: String, commonlyUsedServicesTitle: String, commonlyUsedServices: [String]) {
        self.title = title
        self.titleHeader = titleHeader
        self.description = description
        self.commonlyUsedServicesTitle = commonlyUsedServicesTitle
        self.commonlyUsedServices = commonlyUsedServices
    }
}

// Views/BenefitSummaryView.swift
public struct BenefitSummaryView: View {
    public let benefitSummary: BenefitSummary
    
    public init(benefitSummary: BenefitSummary) {
        self.benefitSummary = benefitSummary
    }
    
    public var body: some View {
        
        VStack(alignment: .leading, spacing: 0) { // Ensure no extra spacing
            headerSection

            VStack(alignment: .leading, spacing: 0) { // Ensure no spacing
                UnderstandYourPlanView(title: benefitSummary.title, description: benefitSummary.description)
                    .foregroundColor(Color(.black))

                Divider()
                    .padding(.vertical, 8)

                CommonlyUsedServicesView(title: benefitSummary.commonlyUsedServicesTitle, services: benefitSummary.commonlyUsedServices)
                    .foregroundColor(Color(.black))
            }
            .padding(16)
            .background(Color(.white)) // Explicitly set background to white
            .cornerRadius(8)
        }
        .background(Color.clear) // Remove unwanted gray background
    }
    
    private var headerSection: some View {
        HStack {
            Text("Understand Your Plan")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(.black))

            Spacer()
        }.background(Color(.systemBackground))
    }
}





// Views/UnderstandYourPlanView.swift
public struct UnderstandYourPlanView: View {
    public let title: String
    public let description: String
    
    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    public var body: some View {
        NavigationLink(destination: DetailView(title: title)) { // Navigate to DetailView
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 8)
        }
    }
}


// Views/CommonlyUsedServicesView.swift
public struct CommonlyUsedServicesView: View {
    public let title: String
    public let services: [String]
    
    public init(title: String, services: [String]) {
        self.title = title
        self.services = services
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            Text("Review benefits details covered under your plan.")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            let rows = services.chunked(into: 2)
            
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { service in
                        ServiceView(service: service)
                    }
                    
                    if row.count == 1 {
                        Spacer()
                    }
                }
            }
        }
        .padding(.top, 8)
    }
}

// Views/ServiceView.swift
public struct ServiceView: View {
    public let service: String
    
    public init(service: String) {
        self.service = service
    }
    
    public var body: some View {
        NavigationLink(destination: DetailView(title: service)) { // Navigate to DetailView
            Text(service)
                .font(.subheadline)
                .foregroundColor(.blue)
                .lineLimit(1)
                .padding()
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


extension View {
    func selectionEffect() -> some View {
        self.onTapGesture {}
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .opacity(0.7)
                    .blur(radius: 4)
                    .padding(-8)
            )
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

public struct DetailView: View {
    public let title: String
    
    public var body: some View {
        List(1...10, id: \.self) { index in
            Text("\(title) - Item \(index)")
        }
        .navigationTitle(title) // Set the title dynamically
    }
}

