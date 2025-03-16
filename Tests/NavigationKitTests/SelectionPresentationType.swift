//
//  SelectionPresentationType.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import SwiftUI

public enum SelectionPresentationType {
    case half
    case full
    
    var detents: Set<PresentationDetent> {
        switch self {
        case .half: return [.medium]
        case .full: return [.large]
        }
    }
    
    var showsDragIndicator: Bool {
        switch self {
        case .half: return true
        case .full: return false
        }
    }
    
    var style: SelectionStyle {
        switch self {
        case .half:
            return SelectionStyle(
                iconBackground: .blue.opacity(0.1),
                iconForeground: .blue,
                checkmark: .blue
            )
        case .full:
            return SelectionStyle(
                iconBackground: .blue.opacity(0.1),
                iconForeground: .blue,
                checkmark: .blue
            )
        }
    }
}
