//
//  TrackingDetailViewModel.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 03/06/22.
//

import Foundation

protocol TrackingDetailViewModelProtocol: ObservableObject {
    func deleteTracking(_ trackingNumber: String) async
}

@MainActor
final class TrackingDetailViewModel: TrackingDetailViewModelProtocol {
    // MARK: - Properties
    private let service: TrackingServiceProtocol
    
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    
    enum State: Equatable {
        case na
        case loading
        case success(tracking: Tracking)
        case failed(error: Error)
        
        static func == (lhs: TrackingDetailViewModel.State,
                        rhs: TrackingDetailViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.na, .na):
                return true
            case (.loading, .loading):
                return true
            case (.success, .success):
                return true
            case (.failed, .failed):
                return true
            default:
                return false
            }
        }
    }
    
    // MARK: - Init
    init(_ service: TrackingServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Network
    func deleteTracking(_ trackingNumber: String) async {
        state = .loading
        hasError = false
        
        do {
            let tracking = try await service.deleteTracking(trackingNumber, carrier: .correios)
            
            self.state = .success(tracking: tracking)
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
