//
//  Selectable.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import SwiftUI

public protocol Selectable: Identifiable & Hashable {
    var displayText: String { get }
}
