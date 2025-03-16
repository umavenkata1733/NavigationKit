//
//  SelectionHeaderView.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//


import SwiftUI

struct SelectionHeaderView<Item: Selectable>: View {
    @ObservedObject var viewModel: SelectionViewModel<Item>
    let style: SelectionStyle
    
    var body: some View {
        // Try to get configuration from JSON
        if let staticSection = ConfigManager.shared.getStaticSection(id: "memberInfo"),
           let dynamicSection = ConfigManager.shared.getDynamicSection(id: "memberInfo"),
           let name = dynamicSection.data.name {
            
            VStack(alignment: .leading) {
                // Title from JSON
                Text(staticSection.title)
                    .foregroundColor(staticSection.styles.colors["titleText"]?.toColor() ?? SelectionConstants.Colors.titleColor)
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: staticSection.styles.layout["spacing"] ?? SelectionConstants.Layout.spacing) {
                    // Circle with icon from JSON
                    Circle()
                        .fill(staticSection.styles.colors["iconBackground"]?.toColor() ?? style.iconBackground)
                        .frame(
                            width: staticSection.styles.layout["iconSize"] ?? SelectionConstants.Layout.iconSize,
                            height: staticSection.styles.layout["iconSize"] ?? SelectionConstants.Layout.iconSize
                        )
                        .overlay(
                            Image(systemName: staticSection.icons?["profile"] ?? "person.2.fill")
                                .foregroundColor(staticSection.styles.colors["iconForeground"]?.toColor() ?? style.iconForeground)
                                .font(.system(size: SelectionConstants.Layout.iconFontSize))
                        )
                    
                    // User's name from dynamic JSON data
                    Text(name)
                        .font(.system(size: SelectionConstants.Layout.contentFontSize))
                        .foregroundColor(staticSection.styles.colors["nameText"]?.toColor() ?? Color(red: 0.1, green: 0.2, blue: 0.4))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    // Chevron from JSON
                    Image(systemName: staticSection.icons?["dropdown"] ?? "chevron.down")
                        .font(.system(size: SelectionConstants.Layout.iconFontSize, weight: .bold))
                        .foregroundColor(staticSection.styles.colors["chevron"]?.toColor() ?? Color(red: 0, green: 0.2, blue: 0.5))
                        .padding(.trailing, 4)
                }
                // Layout from JSON
                .padding(.vertical, 12)
                .padding(.horizontal, staticSection.styles.layout["padding"] ?? SelectionConstants.Layout.padding)
                .background(Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                )
                .shadow(color: SelectionConstants.Colors.shadowColor,
                        radius: 2, x: 0, y: 1)
            }
        } else {
            // Fallback to original implementation if JSON config fails
            VStack(alignment: .leading) {
                Text(SelectionConstants.Strings.viewingInfoTitle)
                    .foregroundColor(SelectionConstants.Colors.titleColor)
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: SelectionConstants.Layout.spacing) {
                    Circle()
                        .fill(Color(red: 0.05, green: 0.05, blue: 0.3))
                        .frame(width: SelectionConstants.Layout.iconSize,
                               height: SelectionConstants.Layout.iconSize)
                        .overlay(
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.white)
                                .font(.system(size: SelectionConstants.Layout.iconFontSize))
                        )
                    
                    Text(viewModel.displayString)
                        .font(.system(size: SelectionConstants.Layout.contentFontSize))
                        .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: SelectionConstants.Layout.iconFontSize, weight: .bold))
                        .foregroundColor(Color(red: 0, green: 0.2, blue: 0.5))
                        .padding(.trailing, 4)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, SelectionConstants.Layout.padding)
                .background(Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                )
                .shadow(color: SelectionConstants.Colors.shadowColor,
                        radius: 2, x: 0, y: 1)
            }
        }
    }
}
