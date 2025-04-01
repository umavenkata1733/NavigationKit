//
//  BannerViewModel.swift
//  Reusable
//
//  Created by Anand on 3/30/25.
//

import Foundation
import Combine
import SwiftUI

/// View model for managing banner data in the UI
///
/// This class acts as a bridge between the use cases layer and the UI.
/// It follows the MVVM pattern and the Dependency Inversion Principle by depending on
/// the BannerUseCases protocol rather than a concrete implementation.
public class BannerViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current collection of banner items
    @Published public var banners: [BannerItem] = []
    
    /// Whether data is currently being loaded
    @Published public var isLoading: Bool = false
    
    /// Any error that occurred during loading
    @Published public var error: Error?
    
    // MARK: - Private Properties
    
    /// Use cases that provide banner operations
    private let bannerUseCases: BannerUseCases
    
    /// Cancellable subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Creates a new banner view model
    ///
    /// - Parameter bannerUseCases: The use cases that will provide banner operations
    public init(bannerUseCases: BannerUseCases) {
        self.bannerUseCases = bannerUseCases
        loadBanners()
    }
    
    // MARK: - Public Methods
    
    /// Load all banners
    public func loadBanners() {
        isLoading = true
        error = nil
        
        bannerUseCases.getAllBanners()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] banners in
                    self?.banners = banners
                }
            )
            .store(in: &cancellables)
    }
    
    /// Load banners from a JSON string
    ///
    /// - Parameter jsonString: The JSON string to parse
    public func loadFromJSONString(_ jsonString: String) {
        isLoading = true
        error = nil
        
        bannerUseCases.loadBannersFromJSONString(jsonString)
            .flatMap { _ in
                self.bannerUseCases.getAllBanners()
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] banners in
                    self?.banners = banners
                }
            )
            .store(in: &cancellables)
    }

    /// Get banners of a specific display style
    ///
    /// - Parameter style: The display style to filter by
    /// - Returns: An array of banner items matching the specified style
    public func getBanners(ofStyle style: BannerItem.DisplayStyle) -> [BannerItem] {
        return banners.filter { $0.displayStyle == style }
    }
    
    /// Get a specific banner by ID
    ///
    /// - Parameter id: The unique identifier of the banner
    /// - Returns: The matching banner item, or nil if not found
    public func getBanner(withId id: String) -> BannerItem? {
        return banners.first { $0.id == id }
    }
}
