import SwiftUI

// Model for your selectable items
struct PlanOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

// Reusable custom picker component that uses sheets
struct SheetPicker<T: Identifiable & Hashable>: View {
    let title: String
    let options: [T]
    @Binding var selectedOption: T
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
                        Text(displayString(selectedOption))
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

// Sheet view for displaying options
struct OptionsSheetView<T: Identifiable & Hashable>: View {
    let options: [T]
    @Binding var selectedOption: T
    let displayString: (T) -> String
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
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
                            
                            if option.id == selectedOption.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Select an Option")
                        .font(.headline)
                }
            }
        }
    }
}

// Usage example
struct ContentView: View {
    @State private var selectedPlan: PlanOption
    let planOptions: [PlanOption]
    
    init() {
        let options = [
            PlanOption(name: "Active 2025 Plan"),
            PlanOption(name: "Premium 2025 Plan"),
            PlanOption(name: "Basic 2025 Plan"),
            PlanOption(name: "Family 2025 Plan"),
            PlanOption(name: "Business 2025 Plan")
        ]
        self._selectedPlan = State(initialValue: options[0])
        self.planOptions = options
    }
    
    var body: some View {
        VStack {
            SheetPicker(
                title: "Select plan type:",
                options: planOptions,
                selectedOption: $selectedPlan,
                displayString: { $0.name }
            )
            .padding()
            
            Spacer()
        }
    }
}
