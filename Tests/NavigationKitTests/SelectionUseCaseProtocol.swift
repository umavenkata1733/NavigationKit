//
//  SelectionUseCaseProtocol.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import SwiftUI

public protocol SelectionUseCaseProtocol<Item> {
    associatedtype Item: Selectable
    func getItems() -> [Item]
    func getSelectedItem() -> Item?
    func getDisplayString() -> String
    func setSelectedItem(_ item: Item?)
}
