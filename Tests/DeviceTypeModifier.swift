//
//  DeviceTypeModifier.swift
//  Reusable
//
//  Created by Anand on 3/30/25.
//

import SwiftUI
// MARK: - Device Detection View Modifier

/// A view modifier that detects the device type and injects it into the environment using the `.deviceType` key.
/// This allows views to adapt their appearance and behavior based on the detected device type.
public struct DeviceTypeModifier: ViewModifier {
    
    /// The detected device type, initialized to `.iPhone` by default.
    @State private var deviceType: DeviceType = .iPhone
    
    public func body(content: Content) -> some View {
        content
            .environment(\.deviceType, deviceType) // Injects the detected device type into the environment.
            .onAppear {
                detectDeviceType()
            }
    }
    
    /// Detects the current device type and updates the `deviceType` state variable.
    private func detectDeviceType() {
        #if os(iOS)
        let device = UIDevice.current
        deviceType = device.userInterfaceIdiom == .pad ? .iPad : .iPhone
        #elseif os(macOS)
        deviceType = .mac
        #endif
    }
}

// MARK: - Adaptive Container

/// A container view that detects device type and adapts the view layout accordingly.
/// It also sets the horizontal size class for further adaptive design.
public struct DeviceAdaptiveContainer<Content: View>: View {
    
    /// Tracks the current horizontal size class (e.g., `.compact` or `.regular`).
    @State private var horizontalSizeClass: UserInterfaceSizeClass?
    
    /// The content view that will be displayed inside the container.
    private let content: Content
    
    /// Initializes the container with a content view using a `ViewBuilder`.
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            content
                .environment(\.horizontalSizeClass, determineSizeClass(with: geometry)) // Injects size class into the environment.
                .modifier(DeviceTypeModifier()) // Applies device detection using `DeviceTypeModifier`.
        }
    }
    
    /// Determines the size class (`compact` or `regular`) based on the view’s width.
    /// - Parameter geometry: The geometry proxy providing view dimensions.
    /// - Returns: The appropriate `UserInterfaceSizeClass` based on the width.
    private func determineSizeClass(with geometry: GeometryProxy) -> UserInterfaceSizeClass {
        return geometry.size.width > 699 ? .regular : .compact
    }
}

// MARK: - View Extensions

extension View {
    
    /// Applies device detection using the `DeviceTypeModifier`, allowing views to adapt based on device type.
    /// - Returns: A view with device type detection applied.
    public func adaptToDevice() -> some View {
        self.modifier(DeviceTypeModifier())
    }
    
    /// Wraps the view in a `DeviceAdaptiveContainer` to adjust layout based on device type and size class.
    /// - Returns: A view within a responsive container.
    public func inAdaptiveContainer() -> some View {
        DeviceAdaptiveContainer {
            self
        }
    }
    
    /// Scales the view proportionally based on the detected device type using `DeviceScalingModifier`.
    /// - Returns: A view that scales its size using device-specific scale factors.
    public func scaleForDevice() -> some View {
        self.modifier(DeviceScalingModifier())
    }
}

// MARK: - Device Scaling Modifier

/// A view modifier that applies a scale effect to views based on the detected device type.
/// Useful for maintaining proportional sizing across different devices.
struct DeviceScalingModifier: ViewModifier {
    
    /// Retrieves the current device type from the environment.
    @Environment(\.deviceType) private var deviceType
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(deviceType.fontScale) // Adjusts the scale based on the device's `fontScale` property.
    }
}
