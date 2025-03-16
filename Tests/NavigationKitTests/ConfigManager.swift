//
//  ConfigManager.swift
//  SelectionViewKit
//
//  Created by Anand on 3/16/25.
//
import Foundation
import SwiftUI

class ConfigManager {
    @MainActor static let shared = ConfigManager()
    private var config: AppConfiguration?
    
    private init() {
        loadConfiguration()
    }
    
    private func loadConfiguration() {
        // In a real app, you'd load from a file using Bundle.main.url
        // For now, we'll embed the JSON string
        let jsonString = """
        {
          "staticContent": {
            "sections": [
              {
                "id": "memberInfo",
                "type": "header",
                "title": "Viewing information for:",
                "icons": {
                  "profile": "person.2.fill",
                  "dropdown": "chevron.down"
                },
                "styles": {
                  "colors": {
                    "titleText": {
                      "color": "gray"
                    },
                    "iconBackground": {
                      "red": 0.05,
                      "green": 0.05,
                      "blue": 0.3
                    },
                    "iconForeground": {
                      "color": "white"
                    },
                    "nameText": {
                      "color": "blue"
                    },
                    "chevron": {
                      "red": 0,
                      "green": 0.2,
                      "blue": 0.5
                    }
                  },
                  "layout": {
                    "cornerRadius": 24,
                    "padding": 16,
                    "iconSize": 40,
                    "spacing": 12
                  }
                }
              }
            ]
          },
          "dynamic": {
            "sections": [
              {
                "id": "memberInfo",
                "data": {
                  "userId": "user123",
                  "name": "Anand"
                }
              }
            ]
          }
        }
        """
        
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                self.config = try JSONDecoder().decode(AppConfiguration.self, from: jsonData)
            } catch {
                print("Error parsing configuration: \(error.localizedDescription)")
            }
        }
    }
    
    func getStaticSection(id: String) -> StaticSection? {
        return config?.staticContent.sections.first { $0.id == id }
    }
    
    func getDynamicSection(id: String) -> DynamicSection? {
        return config?.dynamic.sections.first { $0.id == id }
    }
    
    func getStaticSubsection(sectionId: String, subsectionId: String) -> StaticSection? {
        guard let section = getStaticSection(id: sectionId),
              let subsections = section.subsections else {
            return nil
        }
        return subsections.first { $0.id == subsectionId }
    }
    
    func getDynamicSubsection(sectionId: String, subsectionId: String) -> DynamicSubsection? {
        guard let section = getDynamicSection(id: sectionId),
              let subsections = section.data.subsections else {
            return nil
        }
        return subsections.first { $0.id == subsectionId }
    }
}
