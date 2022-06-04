//
//  NewTrackingViewModel.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 02/06/22.
//

import Foundation

protocol NewTrackingViewModelProtocol: ObservableObject {
    func saveNewTracking() async
}

@MainActor
final class NewTrackingViewModel: NewTrackingViewModelProtocol {
    // MARK: - Properties
    private let service: TrackingService
    
    @Published var trackingNumber: String = ""
    @Published var packageName: String = ""
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    
    var isAbleToContinue: Bool {
        !trackingNumber.isEmpty && !packageName.isEmpty
    }
    
    enum State {
        case na
        case loading
        case success(tracking: Tracking)
        case failed(error: Error)
    }
    
    // MARK: - Init
    init(_ service: TrackingService) {
        self.service = service
    }
    
    // MARK: - Network
    func saveNewTracking() async {
        self.state = .loading
        self.hasError = false
        
        do {
            let model = Package(title: packageName, tracking: trackingNumber)
            let tracking = try await service.saveNewTracking(model)
            
            self.state = .success(tracking: tracking)
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
