//
//  SelectionDelegate.swift
//  SelectionViewKit
//
//  Created by Anand on 2/1/25.
//

import SwiftUI

public protocol SelectionDelegate<Item>: AnyObject {
    associatedtype Item: Selectable
    func didSelect(item: Item?)
}
