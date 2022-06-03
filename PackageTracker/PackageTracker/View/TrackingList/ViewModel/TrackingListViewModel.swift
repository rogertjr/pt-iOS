//
//  TrackingListViewModel.swift
//  PackageTracker
//
//  Created by Rogério Toledo on 30/05/22.
//

import Foundation

protocol TrackingListViewModelProtocol: ObservableObject {
    func fetchTrackings() async
}

@MainActor
final class TrackingListViewModel: TrackingListViewModelProtocol {
    // MARK: - Properties
    private let service: TrackingService
    
    @Published var currentMenu: MenuType = .inTransit
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    @Published private (set) var trackings: [Tracking] = []
    
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
        self.state = .loading
        self.hasError = false
        
        do {
            let data = try await service.fetchTracking("OU317658744BR", carrier: .correios)
            guard let tracking = data else {
                self.state = .failed(error: TrackingServiceError.failed)
                return
            }
            self.trackings = [tracking]
            self.state = .success
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
