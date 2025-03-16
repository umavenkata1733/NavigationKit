//
//  SelectionConstants.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import SwiftUI

public enum SelectionConstants {
    public enum SystemImages {
        static let personIcon = "person.2.fill"
        static let chevronDown = "chevron.down"
        static let checkmark = "checkmark"
    }
    
    public enum Strings {
        static let viewingInfoTitle = "Viewing information for:"
        static let separator = " / "
        static let doneButton = "Done"
    }
    
    public enum Layout {
        static let iconSize: CGFloat = 40
        static let iconFontSize: CGFloat = 14
        static let titleFontSize: CGFloat = 16
        static let contentFontSize: CGFloat = 15
        static let listContentFontSize: CGFloat = 16
        static let spacing: CGFloat = 12
        static let cornerRadius: CGFloat = 8
        static let padding: CGFloat = 16
    }
    
    public enum Colors {
        static let titleColor = Color(.gray)
        static let chevronColor = Color(.systemGray3)
        static let shadowColor = Color.black.opacity(0.05)
    }
}
