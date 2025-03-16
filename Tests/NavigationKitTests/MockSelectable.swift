//
//  MockSelectable.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import Foundation
@testable import SelectionViewKit

struct MockSelectable: Selectable {
    let id = UUID()
    let displayText: String
}
