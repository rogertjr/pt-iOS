//
//  TrackingListViewModel.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import Foundation

protocol TrackingListViewModelProtocol: ObservableObject {
    func fetchTrackings() async
    func fetchTrackingDetails(_ tracking: Tracking) async
}

@MainActor
final class TrackingListViewModel: TrackingListViewModelProtocol {
    // MARK: - Properties
    private let service: TrackingService
    
    @Published var currentMenu: MenuType = .all
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    @Published var trackings: [Tracking] = []
    @Published var selectedTracking: Tracking?
    
    enum State {
        case na
        case loading
        case success
        case failed(error: Error)
    }
    
    // MARK: - Init
    init(_ service: TrackingService) {
        self.service = service
    }
    
    // MARK: - Network
    func fetchTrackings() async {
        state = .loading
        hasError = false
        
        do {
            let data = try await service.fetchTrackings()
            guard let trackings = data else {
                self.state = .failed(error: TrackingServiceError.failed)
                return
            }
            self.trackings = trackings
            self.state = .success
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    func fetchTrackingDetails(_ tracking: Tracking) async {
        state = .loading
        hasError = false
        
        do {
            let data = try await service.fetchTracking(tracking.trackingNumber ?? "",
                                                       carrier: .correios)
            guard let tracking = data else {
                self.state = .failed(error: TrackingServiceError.failed)
                return
            }
            self.selectedTracking = tracking
            if let selectedIndex = self.trackings.firstIndex(where: { $0.id == tracking.id }) {
                self.trackings[selectedIndex] = tracking
            }
            self.state = .success
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
