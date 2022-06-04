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
    private let service: TrackingService
    
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    
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
