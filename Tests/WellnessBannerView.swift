import SwiftUI

// Model for your selectable items
struct PlanOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

// Reusable custom picker component that uses sheets and handles optional values
struct SheetPicker<T: Identifiable & Hashable>: View {
    let title: String
    let options: [T]
    @Binding var selectedOption: T?
    let displayString: (T) -> String
    
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.secondary)
            
            HStack {
                Button(action: {
                    isSheetPresented = true
                }) {
                    HStack {
                        Text(selectedOption.map(displayString) ?? "Select an option")
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                            .padding(.trailing, 16)
                    }
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.15, green: 0.27, blue: 0.6))
                    )
                    .fixedSize(horizontal: true, vertical: false)
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            OptionsSheetView(
                options: options,
                selectedOption: $selectedOption,
                displayString: displayString,
                isPresented: $isSheetPresented
            )
        }
    }
}

// Sheet view for displaying options without NavigationView
struct OptionsSheetView<T: Identifiable & Hashable>: View {
    let options: [T]
    @Binding var selectedOption: T?
    let displayString: (T) -> String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            // Custom header
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .padding()
                
                Spacer()
                
                Text("Select an Option")
                    .font(.headline)
                
                Spacer()
                
                // Empty view to balance the layout
                Button("") {
                    // Empty action
                }
                .opacity(0)
                .padding()
            }
            .padding(.top, 8)
            
            // Divider below header
            Divider()
            
            // List of options
            List {
                ForEach(options) { option in
                    Button(action: {
                        selectedOption = option
                        isPresented = false
                    }) {
                        HStack {
                            Text(displayString(option))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if selectedOption?.id == option.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
    }
}

// Usage example
struct ContentView: View {
    @State private var selectedPlan: PlanOption?
    @State private var planOptions: [PlanOption] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                SheetPicker(
                    title: "Select plan type:",
                    options: planOptions,
                    selectedOption: $selectedPlan,
                    displayString: { $0.name }
                )
                .padding()
            }
            
            Spacer()
        }
        .onAppear {
            fetchPlans()
        }
    }
    
    func fetchPlans() {
        isLoading = true
        
        // Simulate network request with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // This would be your actual API call in a real app
            let options = [
                PlanOption(name: "Active 2025 Plan"),
                PlanOption(name: "Premium 2025 Plan"),
                PlanOption(name: "Basic 2025 Plan"),
                PlanOption(name: "Family 2025 Plan"),
                PlanOption(name: "Business 2025 Plan")
            ]
            
            self.planOptions = options
            if !options.isEmpty {
                self.selectedPlan = options.first
            }
            
            self.isLoading = false
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
