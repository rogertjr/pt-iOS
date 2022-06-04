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
    
    @Published var currentMenu: MenuType = .all
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    @Published var trackings: [Tracking] = []
    
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
}
