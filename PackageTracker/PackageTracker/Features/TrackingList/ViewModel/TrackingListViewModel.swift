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
    private let service: TrackingServiceProtocol
    
    @Published var currentMenu: MenuType = .all
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    @Published var trackings: [Tracking] = []
    @Published var selectedTracking: Tracking?
    
    enum State: Equatable {
        case na
        case loading
        case success
        case failed(error: Error)
        
        static func == (lhs: TrackingListViewModel.State,
                        rhs: TrackingListViewModel.State) -> Bool {
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
    
    // MARK: - Helpers
    func filterTrackings() -> [Tracking] {
        switch currentMenu {
        case .all:
            return trackings
        case .inTransit:
            return trackings.filter { $0.tag != .delivered }
        case .delivered:
            return trackings.filter { $0.tag == .delivered }
        }
    }
    
    // MARK: - Network
    func fetchTrackings() async {
        state = .loading
        hasError = false
        
        do {
            let data = try await service.fetchTrackings()
            guard let trackings = data else {
                self.state = .failed(error: TrackingServiceError.failed)
                self.hasError = true
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
                self.hasError = true
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
