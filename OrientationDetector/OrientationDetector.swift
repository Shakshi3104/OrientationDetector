//
//  OrientationDetector.swift
//  OrientationDetector
//
//  Created by MacBook Pro on 2021/07/17.
//

import Foundation
import Combine
import UIKit


/// return device orientation string
/// - Parameter orientation: UIDeviceOrientation
/// - Returns: device orientation string
func getDeviceOrientation(orientation: UIDeviceOrientation) -> String {
    switch orientation {
    case .landscapeLeft:
        return "Landscape Left"
    case .landscapeRight:
        return "Landscape Right"
    case .portrait:
        return "Portrait"
    case .portraitUpsideDown:
        return "Portrait Upside Down"
    case .faceUp:
        return "Face Up"
    case .faceDown:
        return "Face Down"
    case .unknown:
        return "Unknown"
    @unknown default:
        fatalError()
    }
}


/// get systemName of Image corresponding to the device orientation
/// - Parameter orientation: UIDeviceOrientation
/// - Returns: systemName of Image corresponding to the device orientation
func getDeviceOrientationImageName(orientation: UIDeviceOrientation) -> String {
    switch orientation {
    case .landscapeRight, .landscapeLeft:
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "iphone.landscape"
        default:
            return "ipad.landscape"
        }
    case .portrait, .portraitUpsideDown, .faceUp, .faceDown, .unknown:
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "iphone"
        default:
            return "ipad"
        }
    @unknown default:
        fatalError()
    }
}

/// Orientation Detector using the Combine and @Published
/// referring to https://qiita.com/hcrane/items/48fbf9ccde2090e7202c
class OrientationDetector: ObservableObject {
    
    // MARK: Properties
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Outputs
    private let deviceOrientation$ = PassthroughSubject<UIDeviceOrientation, Never>()
    @Published var deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation
    
    // MARK: Intpus
    func onAppear() {
        NotificationCenter
            .Publisher(center: .default, name: UIDevice.orientationDidChangeNotification, object: nil)
            .map { _ in UIDevice.current.orientation }
            .sink { [weak self] orientation in
                self?.deviceOrientation$.send(orientation)
            }
            .store(in: &cancellables)
        
        deviceOrientation$
            .map { $0 }
            .assign(to: \.deviceOrientation, on: self)
            .store(in: &cancellables)
    }
}
