//
//  ConfigurationModels.swift
//  SelectionViewKit
//
//  Created by Anand on 3/16/25.
//

import SwiftUI

// Core models for parsing JSON configuration
struct AppConfiguration: Decodable {
    let staticContent: StaticConfig
    let dynamic: DynamicConfig
    
    struct StaticConfig: Decodable {
        let sections: [StaticSection]
    }
    
    struct DynamicConfig: Decodable {
        let sections: [DynamicSection]
    }
}

// Static content models
struct StaticSection: Decodable {
    let id: String
    let type: SectionType
    let title: String
    let icons: [String: String]?
    let styles: StylesContent
    let subsections: [StaticSection]?
    let items: [StaticItem]?
    
    enum SectionType: String, Decodable {
        case header
        case card
        case navigationItem
        case buttonGrid
    }
    
    struct StylesContent: Decodable {
        let colors: [String: ColorValue]
        let layout: [String: CGFloat]
    }
}

struct StaticItem: Decodable {
    let id: String
    let title: String
}

// Dynamic content models
struct DynamicSection: Decodable {
    let id: String
    let data: DynamicData
    
    struct DynamicData: Decodable {
        let userId: String?
        let name: String?
        let planId: String?
        let subsections: [DynamicSubsection]?
    }
}

struct DynamicSubsection: Decodable {
    let id: String
    let enabled: Bool
    let hasNavigation: Bool?
    let items: [DynamicItem]?
}

struct DynamicItem: Decodable {
    let id: String
    let enabled: Bool
}

// Color Value types
struct ColorValue: Decodable {
    let color: String?
    let red: CGFloat?
    let green: CGFloat?
    let blue: CGFloat?
    let opacity: CGFloat?
    
    func toColor() -> Color {
        if let color = color {
            // Handle named colors
            switch color {
            case "gray": return Color.gray
            case "white": return Color.white
            case "black": return Color.black
            case "blue": return Color.blue
            default: return Color.black
            }
        } else if let r = red, let g = green, let b = blue {
            // Handle RGB colors
            return Color(red: r, green: g, blue: b, opacity: opacity ?? 1.0)
        }
        return Color.black
    }
}
