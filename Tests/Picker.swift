//
//  Picker.swift
//  NavigationKit
//
//  Created by Anand on 3/5/25.
//
import SwiftUI

struct ContentView: View {
    @State private var selection = "Option 1"
    let options = ["Option 1", "Option 2", "Option 3", "Option 4"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Selected: \(selection)")
                .padding()
            
            MenuPickerView(
                selection: $selection,
                options: options,
                content: {
                    HStack {
                        Text(selection)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                },
                label: { $0 }
            )
            .padding(.horizontal)
        }
    }
}

struct MenuPickerView<SelectionValue: Hashable, Content: View>: View {
    @Binding var selection: SelectionValue
    let options: [SelectionValue]
    let label: (SelectionValue) -> String
    let content: Content
    
    init(
        selection: Binding<SelectionValue>,
        options: [SelectionValue],
        @ViewBuilder content: () -> Content,
        label: @escaping (SelectionValue) -> String
    ) {
        self._selection = selection
        self.options = options
        self.content = content()
        self.label = label
    }
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button {
                    selection = option
                } label: {
                    HStack {
                        Text(label(option))
                        
                        if option == selection {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            content
        }
    }
}


