//
//  SelectionRepositoryProtocol.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import SwiftUI

public protocol SelectionRepositoryProtocol<Item> {
    associatedtype Item: Selectable
    var items: [Item] { get }
    var selectedItem: Item? { get set }
    func select(_ item: Item?)
}
