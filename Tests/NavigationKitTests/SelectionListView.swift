//
//  SelectionListView.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import SwiftUI

struct SelectionListView<Item: Selectable>: View {
    let items: [Item]
    let selectedItem: Item?
    let style: SelectionStyle
    let onSelect: (Item) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List(items) { item in
            Button(action: {
                onSelect(item)
                dismiss()
            }) {
                HStack {
                    Text(item.displayText)
                        .font(.system(size: SelectionConstants.Layout.listContentFontSize))
                    Spacer()
                    if item == selectedItem {
                        Image(systemName: SelectionConstants.SystemImages.checkmark)
                            .foregroundColor(style.checkmark)
                    }
                }
            }
            .foregroundColor(.primary)
        }
        .listStyle(InsetGroupedListStyle())
    }
}
